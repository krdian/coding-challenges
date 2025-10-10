resource "aws_eks_cluster" "this" {
  name     = "sre-challenge-eks"
  role_arn = "arn:aws:iam::${var.aws_account_id}:role/eks-cluster-role"

  vpc_config {
    subnet_ids             = [local.subnets.eks]
    endpoint_public_access = false
  }

  enabled_cluster_log_types = ["api", "authenticator", "audit", "scheduler", "controllerManager"]

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = var.kms_key_arn
    }
  }

  depends_on = [module.vpc]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "sre-challenge-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = [local.subnets.eks]

  scaling_config {
    desired_size = 4
    max_size     = 4
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [aws_eks_cluster.this]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "sre-challenge-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}
