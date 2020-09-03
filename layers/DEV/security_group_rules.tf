
resource "aws_security_group_rule" "rds_mysql_sgr_ing_3306" {
      type = "ingress"
      from_port = 3306
      to_port = 3306
      protocol  = "TCP"
      source_security_group_id = module.naveen_mediawiki_launchtemplate.ec2_sg
      security_group_id = module.naveen_mediawiki_mysqlrds.rds_sg

}

resource "aws_security_group_rule" "rds_mysql_sgr_egr_3306" {
  type = "egress"
  from_port = 3306
  to_port = 3306
  protocol  = "TCP"
  source_security_group_id = module.naveen_mediawiki_mysqlrds.rds_sg
  security_group_id = module.naveen_mediawiki_launchtemplate.ec2_sg

}

resource "aws_security_group_rule" "alb_mediawiki_egr_egr_80" {
  type = "egress"
  from_port = 80
  to_port = 80
  protocol  = "TCP"
  source_security_group_id = module.naveen_mediawiki_launchtemplate.ec2_sg
  security_group_id = module.naveen_mediawiki_loadbalancer.alb_sg

}

resource "aws_security_group_rule" "ec2_mediawiki_sgr_ing_80" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol  = "TCP"
  source_security_group_id = module.naveen_mediawiki_loadbalancer.alb_sg
  security_group_id = module.naveen_mediawiki_launchtemplate.ec2_sg

}

resource "aws_security_group_rule" "alb_sgr_ing_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  cidr_blocks              = ["0.0.0.0/0"]
  security_group_id        = module.naveen_mediawiki_loadbalancer.alb_sg
}