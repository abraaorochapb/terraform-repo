data "aws_ssm_parameter" "ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "ec2_1_terraform" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.aws_instance_size.small
  subnet_id              = aws_subnet.subnet1_terraform.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = "abraao-paula"
  tags                   = local.commom_tags
  user_data              = <<-EOF
        #!/bin/bash
        sudo amazon-linux-extras install -y nginx1
        sudo service nginx start
        sudo rm /usr/share/nginx/html/index.html
        echo "<h1>Welcome to Terraform EC2 Instance 1</h1>" | sudo tee /usr/share/nginx/html/index.html
        EOF
}

resource "aws_instance" "ec2_2_terraform" {
  ami                    = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type          = var.aws_instance_size.small
  subnet_id              = aws_subnet.subnet2_terraform.id
  vpc_security_group_ids = [aws_security_group.instance_sg.id]
  key_name               = "abraao-paula"
  tags                   = local.commom_tags
  user_data              = <<-EOF
        #!/bin/bash
        sudo amazon-linux-extras install -y nginx1
        sudo service nginx start
        sudo rm /usr/share/nginx/html/index.html
        echo "<h1>Welcome to Terraform EC2 Instance 2</h1>" | sudo tee /usr/share/nginx/html/index.html
        EOF
}