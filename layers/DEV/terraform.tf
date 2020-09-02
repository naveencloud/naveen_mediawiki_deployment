#Below is the configuration  to define the required Terraform version and Backed configuration

terraform {
  required_version = ">=0.12.2"
  backend "s3" {
    bucket         = "mediawiki-terraform-state-s3"
    dynamodb_table = "mediawiki-terraform-state-lock"
    key            = "mediawiki/dev/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
  }
}