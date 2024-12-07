terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      projeto = "ada_contabilidade"
      dono    = "jose_rodrigues"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
  environment = var.environment
}

module "nat" {
  source = "./modules/nat"
  environment = var.environment
}

module "s3" {
  source = "./modules/s3"
}

module "sqs" {
  source = "./modules/sqs"
}

module "sns" {
  source = "./modules/sns"
}

module "rds" {
  source = "./modules/rds"
  master_username = var.master_username_rds
  master_password = var.master_password_rds
}

module "lambda" {
  source = "./modules/lambda"
  bucket_name         = module.s3.bucket_name
  process_queue_arn   = module.sqs.process_queue_arn
  notify_queue_arn    = module.sqs.notify_queue_arn
  sns_topic_arn       = module.sns.sns_topic_arn
  rds_instance_arn        = module.rds.rds_cluster_arn
  rds_cluster_endpoint        = module.rds.rds_cluster_endpoint
  rds_db_name               = module.rds.rds_database_name
  rds_username        = var.master_username_rds
  rds_password         = var.master_password_rds
}