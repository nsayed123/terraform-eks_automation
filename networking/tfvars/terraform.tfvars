### Providers Config
aws_profile = "poc"
aws_region  = "ap-south-1"

#### Backend Config
backend_bucket         = "my-terraform-state-bucket-apsouth1"
backend_key            = "networking/tst/terraform.tfstate"
backend_dynamodb_table = "terraform-locks"
backend_region         = "ap-south-1"

### VPC, Subnets
vpc_name   = "eks-rds-vpc"
cidr_block = "10.0.0.0/16"
azs        = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnet_cidrs = [
  "10.0.1.0/24", # AZ-a
  "10.0.2.0/24", # AZ-b
  "10.0.3.0/24"  # AZ-c
]
private_subnet_cidrs_eks = [
  "10.0.11.0/24", # AZ-a
  "10.0.12.0/24", # AZ-b
  "10.0.13.0/24"  # AZ-c
]
private_subnet_cidrs_rds = [
  "10.0.21.0/24", # AZ-a
  "10.0.22.0/24", # AZ-b
  "10.0.23.0/24"  # AZ-c
]

### Bastion
key_name = "ap-south-1"
