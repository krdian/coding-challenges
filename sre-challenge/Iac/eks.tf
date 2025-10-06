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

  depends_on = [module.vpc, module.vpc.subnet_ids]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "sre-challenge-eks-node-group"
  node_role_arn   = "arn:aws:iam::${var.aws_account_id}:role/eks-node-group-role"
  subnet_ids      = [local.subnets.eks]

  scaling_config {
    desired_size = 4
    max_size     = 4
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [aws_eks_cluster.this]
}