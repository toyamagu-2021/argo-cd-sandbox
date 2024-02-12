locals {
  default_tags = {
    "Owner"            = var.owner
    "eks:cluster-name" = "${var.owner}"
  }
}

locals {
  name            = var.owner
  cluster_version = "1.28"
  region          = "ap-northeast-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
