resource "aws_lb" "server_lb" {
  name = "wordpress-lb"
  internal = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups = var.lb_security_group
  subnets = var.public_subnets
}

resource "aws_lb_target_group" "server_tg" {
  name = "wordpress-lb-tg"
  port = var.tg_port
  protocol = var.tg_protocol
  vpc_id = var.vpc_id
  health_check {
    healthy_threshold = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout = var.lb_timeout
    interval = var.lb_interval
  }
}

resource "aws_lb_listener" "server_lb_listener" {
  load_balancer_arn = aws_lb.server_lb.arn
  port = var.lb_port
  protocol = var.lb_protocol
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.server_tg.arn
  }
}