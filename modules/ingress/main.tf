terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

resource "helm_release" "nginx_ingress_public" {
  name       = "nginx-ingress-public"
  namespace  = "ingress-nginx-public"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.10.0"

  create_namespace = true

  values = [
    file("${path.module}/values/nginx-public.yaml")
  ]
}

# nginx ingress - private controller
resource "helm_release" "nginx_ingress_private" {
  name       = "nginx-ingress-private"
  namespace  = "ingress-nginx-private"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.10.0"

  create_namespace = true

  values = [
    file("${path.module}/values/nginx-private.yaml")
  ]
}

resource "kubectl_manifest" "letsencrypt_clusterissuer" {
  yaml_body = file("${path.module}/values/cert-issuer.yaml")
  #   depends_on = [helm_release.cert_manager]
}
