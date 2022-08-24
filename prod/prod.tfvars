cluster_name = "prod_eks_cluster"
cidr_block   = "10.0.0.0/16"
tags = {
  Terraform   = "true"
  Environment = "prod"
}
public_route_table_tags  = "public_route"
private_route_table_tags = "private_route"

name                   = "eks_vpc"
create_vpc             = true
public_subnets         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
azs                    = ["us-east-1a", "us-east-1b", "us-east-1c"]
one_nat_gateway_per_az = false
public_subnet_suffix   = "public"
private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
private_subnet_suffix  = "private"
enable_nat_gateway     = true
single_nat_gateway     = true
enable_dns_hostnames   = true
reuse_nat_ips          = false
create_igw             = true

##############EKS###############
###IAM.TF#####
cluster_role_name = "eks-cluster-role"
worker_role_name  = "eks-node-role"

instance_type           = "t2.medium"
launch_template_name    = "eks-launch-template"
key_name                = "eks_terraform_ssh_key"
volume_size             = 10
worker_desired_capacity = 3
worker_min_size         = 2
worker_max_size         = 4
base_on_demand          = 0
percentage_on_demand    = 25
instance_type_asg1      = "t3.medium"
instance_type_asg2      = "t2.medium"
###SG
cluster_security_group_additional_rules = {}
cluster_security_group_name             = "eks-sg"
cluster_security_group_use_name_prefix  = true
prefix_separator                        = "-"
cluster_security_group_description      = "EKS cluster security group"
cluster_security_group_tags             = {}
##
node_security_group_name             = "node-sg"
node_security_group_use_name_prefix  = true
node_security_group_description      = "Node security group"
node_security_group_tags             = {}
node_security_group_additional_rules = {}
