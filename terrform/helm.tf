# Kubernetes provider for authentication to the EKS cluster (without alias)
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

# Kubernetes provider for Helm deployment (with alias)
#provider "kubernetes" {
#  alias                  = "helm"
#  host                   = data.aws_eks_cluster.cluster.endpoint
#  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
#  token                  = data.aws_eks_cluster_auth.cluster.token
#}

# Helm provider using the aliased Kubernetes provider
provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}


resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  create_namespace = true

  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [module.eks]
}

resource "helm_release" "vertica_operator" {
  name       = "vertica-operator"
  namespace  = "vertica"
  create_namespace = true

  repository = "https://vertica.github.io/charts"
  chart      = "verticadb-operator"

  
  values = [
    <<EOF
webhook:
  certSource: cert-manager
EOF
  ]


  depends_on = [helm_release.cert_manager]
}

