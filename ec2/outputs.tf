output "aws_alb_public_ip" {
  value = "http://${aws_lb.terraform-alb.dns_name}"
  description = "The public IP address of the AWS Application Load Balancer"
}