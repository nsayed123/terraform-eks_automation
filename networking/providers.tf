provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
# provider "kubernetes" {
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.certificate_authority)
#   token                  = data.aws_eks_cluster_auth.this.token

# }

# provider "helm" {
#   kubernetes = {
#     host                   = module.eks.cluster_endpoint
#     cluster_ca_certificate = base64decode(module.eks.certificate_authority)
#     token                  = data.aws_eks_cluster_auth.this.token
#   }
# }

# provider "kubectl" {
#   # Configuration options
#   host                   = module.eks.cluster_endpoint
#   cluster_ca_certificate = base64decode(module.eks.certificate_authority)
#   token                  = data.aws_eks_cluster_auth.this.token
# }