################################################################################
#                                                                              #
#  FRAGILE:                                                                    #
#                                                                              #
#  You need to comment out either option 1 or option 2 but not both.           #
#                                                                              #
#  If you comment out neither, bad things will happen.                         #
#                                                                              #
#  Use Option 1 if you don't have a VPC in your account                        #
#  Use Option 2 (this file) if your Platform Engineering team pre-provisioned  #
#    your account with a VPC and other resources                               #
#                                                                              #
################################################################################

/*
# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

# Find the VPC
data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["on-prem-connected"]
  }
}

# Find all subnets
data "aws_subnets" "all" {
}

# Build a set we can filter further
data "aws_subnet" "sel" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}

# Find the private subnets
data "aws_subnet" "private" {
  for_each = toset([
    for subnet in data.aws_subnet.sel : subnet.id
    if(
      subnet.vpc_id == data.aws_vpc.main.id &&
      startswith(subnet.tags["Name"], "priv-")
    )
  ])
  id = each.value
}

# Find the public subnets
data "aws_subnet" "public" {
  for_each = toset([
    for subnet in data.aws_subnet.sel : subnet.id
    if(
      subnet.vpc_id == data.aws_vpc.main.id &&
      startswith(subnet.tags["Name"], "pub-")
    )
  ])
  id = each.value
}

# Find the internet gateway for this VPC
data "aws_internet_gateway" "gw" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

# Find the public security group
data "aws_security_group" "lb" {
  name = "lb_sg"
}

# Find the private security group
data "aws_security_group" "ecs_tasks" {
  name = "app_sg"
}

# Find the public NAT Gateway
data "aws_nat_gateway" "gw" {
  for_each  = data.aws_subnet.public
  subnet_id = each.value.id
}

// validate that these work correctly:
/ *
output "vpc_main_arn" {
  value = data.aws_vpc.main.arn
}
output "vpc_main_name" {
  value = data.aws_vpc.main.tags["Name"]
}
output "private_subnet_arns" {
  value = [for s in data.aws_subnet.private : s.arn]
}
output "public_subnet_arns" {
  value = [for s in data.aws_subnet.public : s.arn]
}
output "internet_gateway_arn" {
  value = data.aws_internet_gateway.gw.arn
}
output "lb_security_group_arn" {
  value = data.aws_security_group.lb.arn
}
output "ecs_tasks_security_group_arn" {
  value = data.aws_security_group.ecs_tasks.arn
}
*/
