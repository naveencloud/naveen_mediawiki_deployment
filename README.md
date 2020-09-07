# naveen_mediawiki_deployment

Details Related to Repo:

Repo Name: naveen_mediawiki_deployment

AWS REGION TO USE: eu-central-1

Language: Terraform (HCL)

This repo has the code to create required infrastructure to deploy any webapplication (i.e., MediaWiki)

Below are the Resource will get created.,
1. Network Layer - VPC, Subnet, Routes, IGW, NAT Gatway, IAM Role to publish VPC Flow Log
2. RDS Database - MySQL RDS DB with 5.5 version, Parameter Group for RDS, SG for RDS
3. Launch Template - Launch Template for ASG, IAM Instance profile, SG for EC2 Instance
4. CloudFormation Stack - CF Stack to create ASG (With Create/Update policy to support Blue/Green Deployment)
5. Load Balancer - ALB, Target Group, SG for ALB

Jenkins Setup Details:
1. Deploy jenkins in eu-central-1 and Attach IAM Role with "Administrator Access for Experiment only"
2. Terraform, Ansible, Boto2 need to be installed in Jenkins Server
3. Create a Pipeline Job with the "JenkinsFile - Jenkinsfile_mediawiki" in this folder

PRE-REQUISITE:
Below are the list of items required to execute MediaWiki Deployment.,
1. Create Keypair for EC2 instance in AWS Console with name "mediawiki"
2. Download and Store the privatekey in Jenkins Server location "/tmp/mediawiki.pem"
3. Once the Infrastructure creating completed "Manually Execute peering between Jenkins VPC and Newly Created MediaWiki VPC" 
HOW TO USE REPO:
To deploy resource we can directly execute "terraform commands" to deploy infrastructure

OR

We can create Jenkins Pipeline Job in a jenkins setup with jenkinsfile (Jenkins_media) and execute by providing required parameter
Jenkins Parameter:
1. _1_MEDIAWIKI_INFRA  --> Its a boolean option to execute Infra creation stage
2. _1_MEDIAWIKI_DEPLOYMENT --> Its a boolean to execute Ansible Playbook to deploy Mediawiki in EC2 Instance
3. RDS_PASSWORD  --> The Password need to be set to RDS while creating
4. EC2_KEYPAIR_NAME --> The Keypair name need to associate with EC2
2. Environment  --> Its a Choice Parameter to deploy Environment to deploy (Default is "DEV")
3. Action  --> Its a Choice Parameter to execute "Terraform command"

Stages in Jenkins Pipeline:
1. Download Dependency Repo
2. MedaiWiki Infra Creation

Note:
This Repository is depens on the "Terraform core module repository" as shown below and this repo will be download as part of Jenkins pipeline execution
Ansibel "Host" inventory will be handle using Dynamic Inventory 

Dependency Repo: naveen_aws_core_module




