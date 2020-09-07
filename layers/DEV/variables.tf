# Below are the list of variable

variable "region" {
  description = "AWS region"
  default = "eu-central-1"
}

variable "RDS_PASSWORD" {
  description = "RDS Password to create RDS Instance"
}

variable "EC2_KEYPAIR_NAME" {
  description = "EC2 key pair Name"
}

