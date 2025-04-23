variable "vpc_id" {}
variable "private_subnets" {
  type = list(string)
}
variable "eks_node_sg_id" {}
variable "db_username" {}
variable "db_password" {}
