resource "kubernetes_namespace_v1" "argocd_ns" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = kubernetes_namespace_v1.argocd_ns.metadata[0].name

  create_namespace = false

  values = [
    file("${path.module}/values/argo-value.yaml")
  ]

  depends_on = [
    kubernetes_namespace_v1.argocd_ns
  ]

  wait    = true
  timeout = 600
}



// Deploy Argocd Project 
resource "kubectl_manifest" "argocd_project" {
  yaml_body = file("${path.module}./argocd/project.yaml")
  depends_on = [ helm_release.argocd ]
}

// Deploy Argocd Application
resource "kubectl_manifest" "argocd_application" {
  yaml_body = file("${path.module}./argocd/application.yaml")

  depends_on = [kubectl_manifest.argocd_project ]
}

