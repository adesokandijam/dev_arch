resource "aws_db_instance" "my_wordpress_db"{
    allocated_storage = var.db_storage_size
    engine = var.db_engine
    engine_version = var.db_engine_version
    instance_class = var.db_instance_class
    name = var.db_name
    username = var.dbusername
    password = var.db_password
    skip_final_snapshot = true
    db_subnet_group_name = var.db_subnet_group_name
    identifier = var.db_identifier
    vpc_security_group_ids = var.db_security_groups
}