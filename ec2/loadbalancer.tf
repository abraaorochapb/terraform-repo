#aws_lb
resource "aws_lb" "terraform-alb" {
  name               = "${var.project}-${var.company}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [for subnet in aws_subnet.public : subnet.id]
  tags               = local.commom_tags
}
#aws_lb_target_gropu
resource "aws_lb_target_group" "terraform-tg" {
  name     = "${var.project}-${var.company}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_terraform.id
  tags     = local.commom_tags 
}
#aws_lb_listener
resource "aws_lb_listener" "terraform-listener" { 
  load_balancer_arn = aws_lb.terraform-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.terraform-tg.arn
  }
}
#aws_lb_target_group_attachment
resource "aws_lb_target_group_attachment" "ec2_1_terraform_attachment" {
  target_group_arn = aws_lb_target_group.terraform-tg.arn
  target_id        = aws_instance.ec2_1_terraform.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "ec2_2_terraform_attachment" {
  target_group_arn = aws_lb_target_group.terraform-tg.arn
  target_id        = aws_instance.ec2_2_terraform.id
  port             = 80
}