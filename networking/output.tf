output "vpc_id" {
  value = module.network.vpc_id
}

output "bastion_public_ip" {
  value       = module.bastion.public_ip
  description = "Public IP of the Bastion Host"
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids_eks" {
  value = module.network.private_subnet_ids_eks
}

output "private_subnet_ids_rds" {
  value = module.network.private_subnet_ids_rds
}

output "bastion_sg_id" {
  value = module.bastion.bastion_sg_id
}

output "bastion_role_arn" {
  value = module.bastion.bastion_role_arn
}

