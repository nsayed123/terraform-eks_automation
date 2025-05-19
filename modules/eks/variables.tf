variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for EKS"
}

# variable "subnet_ids" {
#   type        = list(string)
#   description = "List of private subnet IDs for EKS"
# }

# variable "cluster_role_arn" {
#   type        = string
#   description = "IAM Role ARN for EKS cluster"
# }

# variable "node_role_arn" {
#   type        = string
#   description = "IAM Role ARN for EKS worker nodes"
# }

variable "desired_size" {
  type        = number
  description = "Desired number of worker nodes"
  default     = 2
}

variable "min_size" {
  type        = number
  description = "Minimum number of worker nodes"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "key_name" {
  type        = string
  description = "EC2 Key pair name for node SSH"
}

variable "bastion_sg_id" {
  type        = string
  description = "Security Group ID of bastion host to allow SSH from"
}

variable "eks_subnet_ids" {

}

variable "bastion_role_arn" {

}
variable "aws_auth_rendered" {

}