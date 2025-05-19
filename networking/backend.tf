


terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = var.backend_bucket
    key            = var.backend_key
    region         = var.backend_region
    dynamodb_table = var.backend_dynamodb_table
    encrypt        = true
    profile        = var.aws_profile
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}




