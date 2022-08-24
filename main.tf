module "eks_with_vpc" {
  source                   = "./resources"
  name                     = var.name
  create_vpc               = var.create_vpc
  cidr_block               = var.cidr_block
  azs                      = var.azs
  public_subnets           = var.public_subnets
  public_subnet_suffix     = var.public_subnet_suffix
  private_subnets          = var.private_subnets
  private_subnet_suffix    = var.private_subnet_suffix
  one_nat_gateway_per_az   = var.one_nat_gateway_per_az
  enable_nat_gateway       = var.enable_nat_gateway
  single_nat_gateway       = var.single_nat_gateway
  enable_dns_hostnames     = var.enable_dns_hostnames
  public_route_table_tags  = var.public_route_table_tags
  private_route_table_tags = var.private_route_table_tags
  tags                     = var.tags
  reuse_nat_ips            = var.reuse_nat_ips
  create_igw               = var.create_igw
  ##
  cluster_role_name = var.cluster_role_name
  worker_role_name  = var.worker_role_name
  ###
  cluster_name            = var.cluster_name
  launch_template_name    = var.launch_template_name
  instance_type           = var.instance_type
  base_on_demand          = var.base_on_demand
  percentage_on_demand    = var.percentage_on_demand
  key_name                = var.key_name
  worker_desired_capacity = var.worker_desired_capacity
  worker_min_size         = var.worker_min_size
  worker_max_size         = var.worker_max_size
  instance_type_asg1      = var.instance_type_asg1
  instance_type_asg2      = var.instance_type_asg2
  volume_size             = var.volume_size
  ###
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules
  cluster_security_group_name             = var.cluster_security_group_name
  cluster_security_group_use_name_prefix  = var.cluster_security_group_use_name_prefix
  prefix_separator                        = var.prefix_separator
  cluster_security_group_description      = var.cluster_security_group_description
  cluster_security_group_tags             = var.cluster_security_group_tags
  ##
  node_security_group_name             = var.node_security_group_name
  node_security_group_use_name_prefix  = var.node_security_group_use_name_prefix
  node_security_group_description      = var.node_security_group_description
  node_security_group_tags             = var.node_security_group_tags
  node_security_group_additional_rules = var.node_security_group_additional_rules
}

output "config-map-aws-auth" {
  value = module.eks_with_vpc.config-map-aws-auth
}
