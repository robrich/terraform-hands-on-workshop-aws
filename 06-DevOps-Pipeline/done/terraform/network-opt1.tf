################################################################################
#                                                                              #
#  FRAGILE:                                                                    #
#                                                                              #
#  You need to comment out either option 1 or option 2 but not both.           #
#                                                                              #
#  If you comment out neither, bad things will happen.                         #
#                                                                              #
#  Use Option 1 (this file) if you don't have a VPC in your account            #
#  Use Option 2 if your Platform Engineering team pre-provisioned              #
#    your account with a VPC and other resources                               #
#                                                                              #
################################################################################


# Fetch AZs in the current region
data "aws_availability_zones" "available" {
}

# Create a VPC
resource "aws_vpc" "main" {
  # FRAGILE: make sure this doesn't conflict with others
  cidr_block = "172.22.0.0/16"

  tags = var.tags
}

# Create var.az_count private subnets, each in a different AZ
resource "aws_subnet" "private" {
  count             = local.availability_zone_count
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.main.id
}

# Create var.az_count public subnets, each in a different AZ
resource "aws_subnet" "public" {
  count                   = local.availability_zone_count
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, local.availability_zone_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
}

# Internet Gateway for the public subnet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# Route the public subnet traffic through the IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.main.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Create a NAT gateway with an Elastic IP for each private subnet to get internet connectivity
resource "aws_eip" "gw" {
  count      = local.availability_zone_count
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]

  tags = var.tags
}

resource "aws_nat_gateway" "gw" {
  count         = local.availability_zone_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.gw.*.id, count.index)

  tags = var.tags
}

# Create a new route table for the private subnets, make it route non-local traffic through the NAT gateway to the internet
resource "aws_route_table" "private" {
  count  = local.availability_zone_count
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.gw.*.id, count.index)
  }
}

# Explicitly associate the newly created route tables to the private subnets (so they don't default to the main route table)
resource "aws_route_table_association" "private" {
  count          = local.availability_zone_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

# ALB security Group: Edit to restrict access to the application
resource "aws_security_group" "lb" {
  name        = "cb-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = local.alb_public_port
    to_port     = local.alb_public_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "cb-ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol        = "tcp"
    from_port       = local.fargate_container_port
    to_port         = local.fargate_container_port
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
