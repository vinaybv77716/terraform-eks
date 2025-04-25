module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "EKS-vpc"
  cidr = var.vpc_cidr

  azs = data.aws_availability_zones.azs.names

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_dns_hostnames = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/elb"               = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"      = 1
  }

}

module "eks" {
  source = "terraform-aws-modules/eks/aws"

  cluster_name    = "my-eks-cluster"
  cluster_version = "1.32"

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true7

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    nodes = {
      min_size     = 1
      max_size     = 3
      desired_size = 2

      instance_type = ["t3.medium"]
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# module "rds" {
#   source              = "./RDS"
#   vpc_id              = module.vpc.vpc_id
#   private_subnets  = module.vpc.private_subnets
#   eks_node_sg_id      = module.eks.node_security_group_id
#   db_username         = "myuser"
#   db_password         = "mypassword123"
# }

resource "aws_eks_access_entry" "example" {
  cluster_name       = "my-eks-cluster" # Replace with your cluster name
  principal_arn      = "arn:aws:iam::200901485389:role/priya_ssm" # Replace with your IAM role ARN
  type = "STANDARD"
}


resource "aws_eks_access_policy_association" "eks_access_admin" {
  cluster_name  = "my-eks-cluster"
  principal_arn = "arn:aws:iam::200901485389:role/priya_ssm"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"

  access_scope {
    type = "cluster"
  }
}






resource "aws_eks_access_entry" "example2" {
  cluster_name       = "my-eks-cluster" # Replace with your cluster name
  principal_arn      = "arn:aws:iam::200901485389:user/project-ciq-poc" # Replace with your IAM role ARN
  type = "STANDARD"
}


resource "aws_eks_access_policy_association" "eks_access_admin2" {
  cluster_name  = "my-eks-cluster"
  principal_arn = "arn:aws:iam::200901485389:user/project-ciq-poc"
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"

  access_scope {
    type = "cluster"
  }
}