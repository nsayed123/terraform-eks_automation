output "cluster_name" {
  value = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

output "certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_role_arn" {
  value = aws_iam_role.eks_node_group_role.arn
}

output "eks_node_group_sg" {
  value = aws_eks_node_group.this.resources[0].remote_access_security_group_id
}