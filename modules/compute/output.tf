output "server_id"{
    value = aws_instance.wordpress_server.*.id
}