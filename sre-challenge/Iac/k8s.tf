data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

resource "helm_release" "ingress-nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = "ingress-nginx"
  create_namespace = true

  depends_on = [aws_eks_cluster.this]

  set = [{
    name  = "controller.service.type"
    value = "LoadBalancer"
  }]
}
resource "kubernetes_namespace" "default" {
  metadata {
    name = "application"
  }
}

resource "kubernetes_deployment" "app" {
  metadata {
    name      = "app"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels = {
      app = "app"
    }
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "app"
      }
    }
    template {
      metadata {
        labels = {
          app = "app"
        }
      }
      spec {
        container {
          name  = "app"
          image = "${aws_ecr_repository.app.repository_url}:latest"
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "app" {
  metadata {
    name      = "app"
    namespace = kubernetes_namespace.default.metadata[0].name
  }
  spec {
    selector = {
      app = kubernetes_deployment.app.metadata[0].labels.app
    }
    port {
      port        = 8080
      target_port = 8080
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_ingress_class" "nginx" {
  metadata {
    name = "nginx"
  }
  spec {
    controller = "k8s.io/ingress-nginx"
  }
}

resource "kubernetes_ingress" "app_ingress" {
  wait_for_load_balancer = true

  metadata {
    name      = "app-ingress"
    namespace = kubernetes_namespace.default.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target"     = "/"
      "kubernetes.io/ingress.class"                    = "nginx"
      "cert-manager.io/cluster-issuer"                 = "letsencrypt-prod"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = "true"
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = "true"
      "nginx.ingress.kubernetes.io/health-check-path"  = "/health"
      "nginx.ingress.kubernetes.io/scheme"             = "internet-facing"
      "nginx.ingress.kubernetes.io/hostname"           = "web.example.com"
      "nginx.ingress.kubernetes.io/loadbalancer-name"  = "sre-challenge-alb"
      "nginx.ingress.kubernetes.io/waf-acl-id"         = module.waf.arn
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "web.example.com"
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.app.metadata[0].name
            service_port = 8080
          }
        }
      }
    }
  }
}

resource "aws_ecr_repository" "app" {
  name                 = "sre-challenge-app"
  image_tag_mutability = "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "sre-challenge-app"
  }

  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = var.kms_key_arn
  }
}
