data "aws_iam_policy_document" "pod_identity_assume_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "argo" {
  name               = "eks-pod-identity-argo"
  assume_role_policy = data.aws_iam_policy_document.pod_identity_assume_policy.json
}

resource "aws_eks_pod_identity_association" "argocd-server" {
  cluster_name    = module.eks_primary.cluster_name
  namespace       = "argo-cd"
  service_account = "argocd-server"
  role_arn        = aws_iam_role.argo.arn
}

resource "aws_eks_pod_identity_association" "argocd-application-controller" {
  cluster_name    = module.eks_primary.cluster_name
  namespace       = "argo-cd"
  service_account = "argocd-application-controller"
  role_arn        = aws_iam_role.argo.arn
}
