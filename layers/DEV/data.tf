#Below is the list of imported subnet related values

data "aws_vpc" "cng" {
  tags = {
    Name = "ca-cng-${var.environment}-vpc"
  }
}

data "aws_subnet" "pri-1" {
  vpc_id = data.aws_vpc.cng.id

  filter {
    name   = "tag:Name"
    values = ["ca-cng-${var.environment}-sub-pri-az1"]
  }
}

data "aws_subnet" "pri-2" {
  vpc_id = data.aws_vpc.cng.id

  filter {
    name   = "tag:Name"
    values = ["ca-cng-${var.environment}-sub-pri-az2"]
  }
}
data "aws_subnet" "pri-3" {
  vpc_id = data.aws_vpc.cng.id

  filter {
    name   = "tag:Name"
    values = ["ca-cng-${var.environment}-sub-pri-az3"]
  }
}

data "aws_ecs_cluster" "ca-cng-ecs-cluster" {
  cluster_name = "ca-cng-${var.environment}-ecs-cluster"
}

data "aws_s3_bucket" "yde_packet_process_s3bucket" {
  bucket = "ca-cng-${var.environment}-data-interchange-snowflake-s3"
}

data "aws_security_group" "rds_wow_msql_sg" {
  name = "ca-cng-${var.environment}-wow-rds-sg"
}

