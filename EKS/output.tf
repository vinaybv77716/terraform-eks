output "vpc_id"{
value=module.vpc.vpc_id
}

output "public_subnets"{
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "private_subnets"{
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "node_security_group_id" {
  description = "ID of the EKS managed node group"
  value       = module.eks.eks_managed_node_groups["nodes"].node_group_id
}

output "eks_node_sg_id" {
  description = "Security group ID used by the EKS managed node group"
  value       = module.eks.node_security_group_id
}

