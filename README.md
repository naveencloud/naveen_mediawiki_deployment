# naveen_mediawiki_deployment

Details Related to Repo:

Repo Name: naveen_mediawiki_deployment

Language: Terraform

This repo has the code to create required infrastructure to deploy any webapplication (i.e., MediaWiki)

Below are the Resource will get created.,
1. Network Layer - VPC, Subnet, Routes, IGW, NAT Gatway, IAM Role to publish VPC Flow Log
2. RDS Database - MySQL RDS DB with 5.5 version, Parameter Group for RDS, SG for RDS
3. Launch Template - Launch Template for ASG, IAM Instance profile, SG for EC2 Instance
4. CloudFormation Stack - CF Stack to create ASG (With Create/Update policy to support Blue/Green Deployment)
5. Load Balancer - ALB, Target Group, SG for ALB

HOW TO USE REPO:
To deploy resource we can directly execute "terraform commands" to deploy infrastructure

OR

We can create Jenkins Pipeline Job in a jenkins setup with jenkinsfile (Jenkins_media) and execute by providing required parameter
Jenkins Parameter:
1. _1_MEDIAWIKI_INFRA  --> Its a boolean option to execute Infra creation stage
2. Environment  --> Its a Choice Parameter to deploy Environment to deploy (Default is "DEV")
3. Action  --> Its a Choice Parameter to execute "Terraform command"

Stages in Jenkins Pipeline:
1. Download Dependency Repo
2. MedaiWiki Infra Creation

Note:
This Repository is depen on the "Terraform core module repository" as shown below and this repo will be download as part of Jenkins pipeline execution

Dependency Repo: naveen_aws_core_module

Reference Architecture:



