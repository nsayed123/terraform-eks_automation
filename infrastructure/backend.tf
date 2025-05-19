

terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = "my-terraform-state-bucket-apsouth1"
    key            = "eks-rds/tst/terraform.tfstate"
    region         = "ap-south-1"
    use_lockfile  = true
    encrypt        = true
    profile        = "poc"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.36.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.0-pre2"
    }
    kubectl = {
      source = "gavinbunney/kubectl"
      # version = "~> 1.14"
    }
  }
}


provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token

}

provider "helm" {
  kubernetes = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.certificate_authority)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  # Configuration options
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.certificate_authority)
  token                  = data.aws_eks_cluster_auth.this.token
}


