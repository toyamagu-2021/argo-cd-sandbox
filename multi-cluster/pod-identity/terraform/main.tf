module "eks_primary" {
  providers = {
    kubernetes = kubernetes.primary
  }
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${local.name}-primary"
  cluster_version = local.cluster_version

  cluster_endpoint_public_access = true
  cluster_encryption_config      = {}
  create_cloudwatch_log_group    = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    one = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
}

module "eks_secondary" {
  providers = {
    kubernetes = kubernetes.secondary
  }

  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "${local.name}-secondary"
  cluster_version = local.cluster_version

  cluster_endpoint_public_access = true
  cluster_encryption_config      = {}
  create_cloudwatch_log_group    = false

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["t3.large"]
  }

  eks_managed_node_groups = {
    one = {
      min_size     = 1
      max_size     = 10
      desired_size = 1

      instance_types = ["t3.large"]
      capacity_type  = "SPOT"
    }
  }

  # aws-auth configmap
  manage_aws_auth_configmap = true

  aws_auth_accounts = [
    data.aws_caller_identity.current.account_id
  ]
  aws_auth_roles = [
    {
      rolearn = resource.aws_iam_role.argo.arn
      username = "primary-cluster"
      groups   = ["system:masters"]
    }
  ]
}

resource "aws_eks_addon" "example" {
  cluster_name = module.eks_primary.cluster_name
  addon_name   = "eks-pod-identity-agent"
}
