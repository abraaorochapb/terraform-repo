#data
data "aws_availability_zones" "available" {
  state = "available"
}

#resources
resource "aws_vpc" "vpc_terraform" {
  cidr_block           = var.vpc_cidr_block
  tags                 = local.commom_tags
  enable_dns_hostnames = var.enable_dns_hostnames
}

resource "aws_internet_gateway" "igw_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id
  tags   = local.commom_tags
}

resource "aws_subnet" "subnet1_terraform" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.public_subnet_cidr_block[0]
  availability_zone       = data.aws_availability_zones.available.names[0]
  tags                    = local.commom_tags
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_subnet" "subnet2_terraform" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = var.public_subnet_cidr_block[1]
  availability_zone       = data.aws_availability_zones.available.names[1]
  tags                    = local.commom_tags
  map_public_ip_on_launch = var.map_public_ip_on_launch
}

resource "aws_route_table" "rt_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id
  tags   = local.commom_tags
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_terraform.id
  }
}

resource "aws_route_table_association" "rt_terraform_subnet1" {
  subnet_id      = aws_subnet.subnet1_terraform.id
  route_table_id = aws_route_table.rt_terraform.id
}

resource "aws_route_table_association" "rt_terraform_subnet2" {
  subnet_id      = aws_subnet.subnet2_terraform.id
  route_table_id = aws_route_table.rt_terraform.id
}

#security groups
resource "aws_security_group" "instance_sg" {
  vpc_id      = aws_vpc.vpc_terraform.id
  name        = "instance_sg"
  description = "Security group for Terraform EC2 instance"

  # Allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  # Allow HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "alb_sg" {
  vpc_id      = aws_vpc.vpc_terraform.id
  name        = "alb_sg"
  description = "Security group for Terraform EC2 instance"

  # Allow HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}