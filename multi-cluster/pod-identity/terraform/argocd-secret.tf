resource "kubernetes_secret" "seconary" {
  provider = kubernetes.primary
  metadata {
    name      = module.eks_secondary.cluster_name
    namespace = "argo-cd"
    labels = {
      "argocd.argoproj.io/secret-type" = "cluster"
    }
  }

  data = {
    name   = module.eks_secondary.cluster_name
    server = module.eks_secondary.cluster_endpoint
    config = jsonencode(
      {
        awsAuthConfig = {
          clusterName = module.eks_secondary.cluster_name
        }
        tlsClientConfig = {
          insecure = false
          caData   = module.eks_secondary.cluster_certificate_authority_data
        }
      }
    )
  }
}
resource "kubernetes_namespace" "example" {
  provider = kubernetes.primary
  metadata {
    name = "argo-cd"
  }
}
