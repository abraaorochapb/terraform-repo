#providers
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

#data
data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#resources
resource "aws_vpc" "vpc_terraform" {
  cidr_block           = "10.0.0.0/16"
  tags                 = local.commom_tags
  enable_dns_hostnames = var.enable_dns_hostnames
}

resource "aws_internet_gateway" "igw_terraform" {
  vpc_id = aws_vpc.vpc_terraform.id
  tags   = local.commom_tags
}

resource "aws_subnet" "subnet1_terraform" {
  vpc_id                  = aws_vpc.vpc_terraform.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
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

#security groups
resource "aws_security_group" "sg_terraform" {
  vpc_id      = aws_vpc.vpc_terraform.id
  name        = "sg_terraform"
  description = "Security group for Terraform EC2 instance"

  # Allow SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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

#instances
resource "aws_instance" "ec2_terraform" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.aws_instance_size.small
  subnet_id              = aws_subnet.subnet1_terraform.id
  vpc_security_group_ids = [aws_security_group.sg_terraform.id]
  key_name               = "your_key_pair_name"
  tags                   = local.commom_tags
  user_data              = <<-EOF
        #!/bin/bash
        sudo amazon-linux-extras install -y nginx1
        sudo service nginx start
        sudo rm /usr/share/nginx/html/index.html
        echo "<h1>Welcome to Terraform EC2 Instance</h1>" | sudo tee /usr/share/nginx/html/index.html
        EOF
}