resource "aws_vpc" "eks_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames
  instance_tenancy     = "default"
  tags = {
    "Name"                                      = var.cluster_name
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

################################################################################
# Public subnet
################################################################################
resource "aws_subnet" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 && (false == var.one_nat_gateway_per_az || length(var.public_subnets) >= length(var.azs)) ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = element(concat(var.public_subnets, [""]), count.index)
  availability_zone       = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.public_subnet_suffix}-%s",
        element(var.azs, count.index),

      )
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    },
    var.tags,

  )
}


################################################################################
# Private subnet
################################################################################

resource "aws_subnet" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  vpc_id               = aws_vpc.eks_vpc.id
  cidr_block           = var.private_subnets[count.index]
  availability_zone    = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null
  availability_zone_id = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) == 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.private_subnet_suffix}-%s",
        element(var.azs, count.index),
      )
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    },
    var.tags,
  )
}

#####################ROUTE TABLES############################
# custom route tables for private and public subnets for explicit control how each subnet routes traffic.
##############################################################

resource "aws_route_table" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = var.public_route_table_tags,
  }

}


resource "aws_route_table_association" "public" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}
#########################
locals {
  max_subnet_length = max(
    length(var.private_subnets),
  )

  nat_gateway_count = var.single_nat_gateway ? 1 : var.one_nat_gateway_per_az ? length(var.azs) : local.max_subnet_length
}
#########################
resource "aws_route_table" "private" {
  count = var.create_vpc && length(var.public_subnets) > 0 ? local.nat_gateway_count : 0

  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = var.private_route_table_tags,
  }
}

resource "aws_route_table_association" "private" {
  count = var.create_vpc && length(var.private_subnets) > 0 ? length(var.private_subnets) : 0

  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(
    aws_route_table.private.*.id,
    var.single_nat_gateway ? 0 : count.index,
  )
}
###########################NAT GATEWAY####################################
#you must specify the public subnet
#set variable one_nat_gateway_per_az to true for HA and bandwidth reasons.
#I will only create one  for cost-effective infra
##########################################################################
resource "aws_nat_gateway" "eks_vpc" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  allocation_id = element(
    aws_eip.nat[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )
  subnet_id = element(
    aws_subnet.public[*].id,
    var.single_nat_gateway ? 0 : count.index,
  )

  tags = merge(
    {
      "Name" = format(
        "${var.name}-%s",
        element(var.azs, var.single_nat_gateway ? 0 : count.index),
      )
    },
    var.tags,
    # var.nat_gateway_tags,
  )

  depends_on = [aws_internet_gateway.eks_vpc]
}

######################################################ELASTIC IP###################
#Elastic IP address to associate with the NAT gateway
####################################################################################

resource "aws_eip" "nat" {
  # count = var.create_vpc && var.enable_nat_gateway && false == var.reuse_nat_ips ? aws_nat_gateway.eks_vpc.ids : 0
  vpc = true

  tags = var.tags
  # var.nat_eip_tags,

}
##########################ROUTE TABLE################
#eks_vpc enables instances in your private subnets to communicate with the internet.
######################################################

resource "aws_route" "private_nat_gateway" {
  count = var.create_vpc && var.enable_nat_gateway ? local.nat_gateway_count : 0

  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.eks_vpc.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

#########################INTERNET GATEWAY###################################

resource "aws_internet_gateway" "eks_vpc" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    {
      "Name" = format("%s", var.name)
    },
    var.tags,
    # var.igw_tags,
  )
}
###################################ROUTE TABLE###################################

resource "aws_route" "public_internet_gateway" {
  count = var.create_vpc && var.create_igw && length(var.public_subnets) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_vpc[0].id

  timeouts {
    create = "5m"
  }
}
