provider "aws" {
  default_tags {
    tags = local.default_tags
  }
}

provider "kubernetes" {
  alias                  = "primary"
  host                   = module.eks_primary.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_primary.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_primary.cluster_name]
  }
}

provider "kubernetes" {
  alias                  = "secondary"
  host                   = module.eks_secondary.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_secondary.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks_secondary.cluster_name]
  }
}

