

variable "network_tfstate_bucket" {

}

variable "network_tfstate_key" {

}

variable "network_tfstate_profile" {

}
variable "network_tfstate_region" {

}

variable "key_name" {
  description = "Name of the EC2 Key Pair for Bastion Host"
  type        = string
}

variable "bastion_allowed_ips" {
  description = "CIDR blocks allowed to SSH into Bastion"
  type        = list(string)
}

# variable "db_username" {
#   type        = string
#   description = "Database username"
# }

# variable "db_password" {
#   type        = string
#   description = "Database password"
#   sensitive   = true
# }

variable "db_secret_name" {

}
# variable "superset_secret" {

# }