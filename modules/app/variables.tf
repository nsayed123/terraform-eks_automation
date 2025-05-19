
variable "namespace" {
  type    = string
  default = "superset"
}

# variable "postgres_secret_name" {
#   type = string
#   description = "Name of the AWS Secrets Manager secret containing PostgreSQL credentials"
# }

variable "postgres_host" {
  type = string
  description = "PostgreSQL hostname"
}

variable "domain_name" {
  type = string
  description = "Domain for Superset ingress (e.g. superset.example.com)"
}

variable "ingress_class" {
  type    = string
  default = "public"
}
variable "postgres_secret_username" {
  
}
variable "postgres_secret_password" {
  
}