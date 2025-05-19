variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for DB subnet group"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "allowed_source_sgs" {
  type        = list(string)
  description = "Security groups allowed to access RDS"
  default     = []
}
