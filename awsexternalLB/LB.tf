provider "aws" {
  region = "us-east-1"
}

resource "aws_lb" "nlb" {
  name               = "external-lb"
  internal           = false
  load_balancer_type = "network"
  subnets            = ["", ""]  # Needs IDs
}

resource "aws_lb_target_group" "ip_targets" {
  name     = "ip-targets"
  port     = 80
  protocol = "TCP"
  vpc_id   = "" # needs ID

  target_type = "ip"

  health_check {
    protocol = "TCP"
    port     = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "target1" {
  target_group_arn = aws_lb_target_group.ip_targets.arn
  target_id        = ""  # Replace this with AWS cloudshirt loadbancer
  port             = 80
}

resource "aws_lb_target_group_attachment" "target2" {
  target_group_arn = aws_lb_target_group.ip_targets.arn
  target_id        = ""  # Replace this with Google cloud cluster loadbalancer
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb. nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip_targets.arn
  }
}
