terraform {
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = "my-terraform-state-bucket-apsouth1"
    key            = "networking/tst/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "poc"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}




