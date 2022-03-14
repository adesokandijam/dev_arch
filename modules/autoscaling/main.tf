resource "aws_ami_from_instance" "web_ami" {
  name = "my-ami"
  source_instance_id = var.source_instance_id
}


resource "aws_launch_configuration" "wordpress_lc" {
    name = "web-config"
    image_id = aws_ami_from_instance.web_ami.id
    instance_type = var.instance_type

    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "server-asg" {
    name = "web-asg"
    max_size = var.max_size
    min_size = var.min_size
    health_check_grace_period = var.health_check_grace_period
    health_check_type = var.health_check_type
    desired_capacity = var.desired_capacity
    force_delete = true
    launch_configuration = aws_launch_configuration.wordpress_lc.id
    target_group_arns = var.lb_tg_arns
    vpc_zone_identifier = var.public_subnets
}