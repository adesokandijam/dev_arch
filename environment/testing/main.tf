module "networking" {
  source               = "../../modules/networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

/* module "database" {
  source               = "../../modules/database"
  db_storage_size      = 10
  db_engine            = "mysql"
  db_instance_class    = "db.t2.micro"
  db_name              = "wordpress"
  dbusername           = "Dijam"
  db_password          = "12345678"
  db_subnet_group_name = module.networking.db_subnet_group_name
  db_engine_version    = "5.7"
  db_identifier        = "wordpress-database"
  db_security_groups   = [module.networking.db_security_id]
} */

module "compute" {
  source               = "../../modules/compute"
  server_instance_type = "t2.micro"
  server_count         = 1
  server_sgs           = module.networking.server_security_group_id
  public_subnet        = module.networking.server_public_subnet
  server_volume_size   = 10
  tg_arn = module.loadbalancing.tg_arn
  tg_port = 80
}

module "loadbalancing" {
  source = "../../modules/loadbalancing"
  lb_internal = false
  lb_type = "application"
  lb_security_group = module.networking.server_security_group_id
  public_subnets = module.networking.server_public_subnet
  lb_port = 8000
  lb_protocol = "HTTP"
  vpc_id = module.networking.vpc_id
  healthy_threshold = 5
  unhealthy_threshold = 2
  lb_timeout = 3
  lb_interval = 30
  tg_port = 80
  tg_protocol = "HTTP"
}

module "autoscaling" {
  source = "../../modules/autoscaling"
  source_instance_id = module.compute.server_id[0]
  instance_type = "t2.micro"
  max_size = 3
  min_size = 1
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = 2
  lb_tg_arns = [module.loadbalancing.tg_arn]
  public_subnets = module.networking.server_public_subnet
}