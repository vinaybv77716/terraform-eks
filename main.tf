module "eks" {
   source = "./EKS"
   vpc_cidr = var.vpc_cidr
   private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
}

module "rds" {
  source              = "./rds"
  vpc_id              = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnets
  eks_node_sg_id      = module.eks.node_security_group_id
  db_username         = "myuser"
  db_password         = "mypassword123"
}
