
variable "aws_region" {

}
variable "aws_profile" {

}



### Networking state output details
variable "network_tfstate_bucket" {

}

variable "network_tfstate_key" {

}

variable "network_tfstate_profile" {

}
variable "network_tfstate_region" {

}


### EKS cluster details
variable "eks_cluster_name" {

}
variable "eks_ng_desired_size" {

}
variable "eks_ng_min_size" {

}
variable "eks_ng_max_size" {

}

variable "key_name" {
  description = "Name of the EC2 Key Pair for Bastion Host"
  type        = string
}


variable "rds_cluster_name" {

}


variable "db_secret_name" {

}

variable "dns_zone_name" {

}
variable "dns_public_hostname" {

}
