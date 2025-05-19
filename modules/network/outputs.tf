output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids_eks" {
  value = aws_subnet.private_eks[*].id
}

output "private_subnet_ids_rds" {
  value = aws_subnet.private_rds[*].id
}

