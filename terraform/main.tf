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
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  default_tags {
    tags = {
      projeto = var.project_name
      dono    = "jose_rodrigues"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  environment        = var.environment
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Environment = var.environment
  }
}

module "rds" {
  source = "./modules/rds"
  environment = var.environment
  subnet_ids                  = module.vpc.subnet_ids["Private-DB"]
  database_security_group_id  = module.vpc.database_security_group_id
  db_engine         = "postgres"
  db_engine_version = "13.11"
  db_instance_class = "db.t3.micro"
  db_username = var.master_username_rds
  db_password = var.master_password_rds
  allocated_storage     = 20
  backup_retention_period = 1
  multi_az              = false
  database_name         = "contabilidade2025"
  tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Environment = var.environment
  }
}

module "s3" {
  source = "./modules/s3"
  environment = var.environment
  iam_user_arn = var.iam_user_arn
  bucket_name = "application-ada-contabilidade-bucket-public-s3"
}

module "sqs" {
  source = "./modules/sqs"
  prefix = "ada"
  
  queues = {
    notify = {
      name = "notify-queue"
      allow_lambda_access = true
    }
  }
}

module "sns" {
  source = "./modules/sns"
  email_sns  =  var.email_sns
}

module "lambda" {
  source = "./modules/lambda"

  environment           = var.environment
  bucket_name           = module.s3.bucket_name
  sqs_queue_arn         = module.sqs.queue_arns["notify"]
  sns_topic_arn         = module.sns.sns_topic_arn
  rds_username          = var.master_username_rds
  rds_password          = var.master_password_rds
  rds_cluster_endpoint  = module.rds.db_instance_endpoint
  rds_db_name           = "contabilidade2025"
  create_notify_user_lambda = true
  create_event_source_mapping = true
}