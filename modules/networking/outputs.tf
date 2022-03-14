output "db_subnet_group_name" {
    value = aws_db_subnet_group.wordpress_db_subnet_group.name
}

output "db_security_id" {
  value = aws_security_group.db_security_group.id
}

output "server_security_group_id"{
  value = [aws_security_group.dev_arch_sec_group.id, aws_security_group.dev_arch_sec_group1.id]
}

output "server_public_subnet" {
  value = aws_subnet.public_subnet.*.id
}

output "vpc_id"{
  value = aws_vpc.dev_arch_vpc.id
}