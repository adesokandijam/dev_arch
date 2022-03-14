resource "aws_instance" "wordpress_server" {
  tags = {
      Name = "Wordpress Server"
  }
  ami = data.aws_ami.server_ami.id
  instance_type = var.server_instance_type
  count = var.server_count
  vpc_security_group_ids = var.server_sgs
  subnet_id = var.public_subnet[count.index]
  root_block_device {
    volume_size = var.server_volume_size
  }
  key_name = aws_key_pair.server_pub_key.id
}

data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "aws_lb_target_group_attachment" "server_lb_attachment" {
  target_group_arn = var.tg_arn
  target_id = aws_instance.wordpress_server[count.index].id
  port = var.tg_port
  count = var.server_count
}

resource "aws_key_pair" "server_pub_key" {
  key_name = "id_rsa"
  public_key = file("/Users/abdulmajidadesokan/.ssh/id_rsa.pub")
}