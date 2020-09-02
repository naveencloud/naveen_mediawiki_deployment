# Below are the list of resource to create MediaWiki Infrastructure
module "naveen_mediawiki_vpc" {
  source = "../../modules/naveen_aws_core_module/vpc"

  region = "eu-central-1"
  account_id = "449701711604"
  vpc_cidr   = "192.168.0.0/16"
  environment = "dev"
  subnets_cidrs = {
    public       = ["192.168.0.0/24", "192.168.3.0/24", "192.168.6.0/24"]
    private_app  = ["192.168.1.0/24", "192.168.4.0/24", "192.168.7.0/24"]
    private_data = ["192.168.2.0/24", "192.168.5.0/24", "192.168.8.0/24"]
  }
  availability_zones = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  vpc_name           = "mediawiki"
  vpc_flow_log_group_name = "mediawiki"
  sub_services_names = {
    public       = "pub"
    private_app  = "pri"
    private_data = "db"
  }
  common_tags = {
    Environment = "development"
  }

}

module "naveen_mediawiki_parametergroup" {
  source = "../../modules/naveen_aws_core_module/rds-mysql-parametergroup"

  rds_name = "mediawiki"
  rds_parameter_group_family = "mysql5.5"

}

module "naveen_mediawiki_mysqlrds" {
  source = "../../modules/naveen_aws_core_module/rds-mysql"

  rds_name = "mediawiki"
  rds_parameter_group_family = "mysql5.5"
  rds_encryption  = false
  rds_db_engine   = "mysql"
  rds_allocated_storage = "10"
  rds_storage_type      = "gp2"
  rds_engine_version    = "5.5.54"
  rds_instance_class    = "db.t2.micro"
  rds_backup_retention_days = "7"
  rds_multi_az              = false
  rds_db_subnet_ids         = [module.naveen_mediawiki_vpc.dbsubnet1,module.naveen_mediawiki_vpc.dbsubnet2]
  vpc_id                    = module.naveen_mediawiki_vpc.vpcid
  environment               = "dev"
  db_username               = "armin"
  db_password               = "welcome123"

}

module "naveen_mediawiki_launchtemplate" {
  source = "../../modules/naveen_aws_core_module/launchtemplate"

  core_lt_name     = "mediawiki"
  core_lt_ami    = "ami-0c115dbd34c69a004"
  vpc_id         = module.naveen_mediawiki_vpc.vpcid
  region     = "eu-central-1"
  cf_StackName   = "mediawiki"
  cf_resource_id  = "mediaswikiasg"
  instance_detail_monitoring = false
  resource_to_tag        = "volume"
  ebs_optimized          = true
  environment            = "dev"
  ec2_name               = "mediawiki-dev"

}

module "naveen_mediawiki_loadbalancer" {
  source = "../../modules/naveen_aws_core_module/alb"

  environment = "dev"
  alb_name    = "mediawiki"
  vpc_id      = module.naveen_mediawiki_vpc.vpcid
  subnetid    = [module.naveen_mediawiki_vpc.pubsubnet1,module.naveen_mediawiki_vpc.pubsubnet2]
  application_service_port = 80
  lb_internal  = false
  idle_timeout = 300
  lb_tg_protocol = http
  lb_tg_port     = 80
  lb_tg_hc_path  = "/"
  lb_tg_hc_matcher = ""
  lb_tg_hc_timeout = 120
  lb_tg_hc_interval = 30
  lb_tg_hc_hthreshold = 3
  lb_tg_hc_uhthreshold = 5
}

module "naveen_mediawiki_asg" {
  source = "../../modules/naveen_aws_core_module/autoscaling"

  cf_stack_name   = "mediawiki"
  asg_name        = "mediaswikiasg"
  asg_max_size    = 1
  asg_desired_capacity  = 1
  asg_min_size          = 1
  health_check_type     = "ec2"
  health_check_grace_period = 60
  default_cooldown          = 120
  tg_arn                    = module.naveen_mediawiki_loadbalancer.core_tg_id
  termination_policies      = ["OldestInstance"]
  VPCZoneIdentifier1        = module.naveen_mediawiki_vpc.appsubnet1
  VPCZoneIdentifier2        = module.naveen_mediawiki_vpc.appsubnet2
  enabled_metrics           = ["GroupTotalInstances"]
  OnDemandAllocationStrategy = "prioritized"
  on_demand_base_capacity    = 50
  launch_template_version    = "$Latest"
  on_demand_percentage_above_base_capacity = 50
  spot_max_price     = ""
  spot_instance_pools = 5
  launch_template_id  = "${join("", module.naveen_mediawiki_launchtemplate.lt_id)}"
  spot_allocation_strategy  = "lowest-price"
  spot_instance_type1       = "t2.micro"
  ec2_name                  = "mediawiki"
  environment               = "dev"
  cnf_asg_resourcename      = "mediaswikiasg"
}

/*

resource "aws_security_group_rule" "ecs_container_sgr_egr_80" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = module.le_packet_process_ecs_service.core_ecs_container_sg
}

resource "aws_security_group_rule" "ecs_container_sgr_egr_443" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = module.le_packet_process_ecs_service.core_ecs_container_sg
}

resource "aws_security_group_rule" "ecs_container_sgr_egr_3306" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  cidr_blocks              = [var.vpc_cird_range]
  security_group_id        = module.le_packet_process_ecs_service.core_ecs_container_sg
}

resource "aws_security_group_rule" "rds_wowmysql_sgr_ing_3306" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "TCP"
  source_security_group_id = module.le_packet_process_ecs_service.core_ecs_container_sg
  security_group_id        = data.aws_security_group.rds_wow_msql_sg.id

}

resource "aws_security_group_rule" "ecs_container_sgr_egr_389" {
  type                     = "egress"
  from_port                = 389
  to_port                  = 389
  protocol                 = "TCP"
  cidr_blocks              = ["10.0.0.0/8"]
  security_group_id        = module.le_packet_process_ecs_service.core_ecs_container_sg
}

resource "aws_security_group_rule" "ecs_container_sgr_igr_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "TCP"
  cidr_blocks              = [var.vpc_cird_range]
  security_group_id        = module.le_packet_process_ecs_service.core_ecs_container_sg
}

resource "aws_security_group_rule" "ecs_container_sgr_egr_53" {
  type = "egress"
  from_port = 53
  to_port = 53
  protocol = "udp"
  cidr_blocks = split(",", "10.169.226.28/32,10.169.226.115/32")
  security_group_id = module.le_packet_process_ecs_service.core_ecs_container_sg
}

*/
