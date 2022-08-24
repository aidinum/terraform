
variable "cluster_name" {}
#######VPC############
variable "cidr_block" {}
variable "create_vpc" {}
variable "public_subnets" {}
variable "azs" {}
variable "name" {}
variable "one_nat_gateway_per_az" {}
variable "public_subnet_suffix" {}
variable "private_subnets" {}
variable "private_subnet_suffix" {}
variable "tags" {}
variable "public_route_table_tags" {}
variable "private_route_table_tags" {}
variable "single_nat_gateway" {}
variable "enable_dns_hostnames" {}
variable "enable_nat_gateway" {}
variable "reuse_nat_ips" {}
variable "create_igw" {}
#########EKS##########
variable "cluster_role_name" {}
variable "worker_role_name" {}
variable "instance_type" {}
variable "launch_template_name" {}
variable "key_name" {}
variable "volume_size" {}
variable "worker_desired_capacity" {}
variable "worker_min_size" {}
variable "worker_max_size" {}
variable "base_on_demand" {}
variable "percentage_on_demand" {}
variable "instance_type_asg1" {}
variable "instance_type_asg2" {}
#####SG
variable "cluster_security_group_additional_rules" {}
variable "cluster_security_group_name" {}
variable "cluster_security_group_use_name_prefix" {}
variable "prefix_separator" {}
variable "cluster_security_group_description" {}
variable "cluster_security_group_tags" {}
##
variable "node_security_group_name" {}
variable "node_security_group_use_name_prefix" {}
variable "node_security_group_description" {}
variable "node_security_group_tags" {}
variable "node_security_group_additional_rules" {}
