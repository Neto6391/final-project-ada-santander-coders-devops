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
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  default_tags {
    tags = {
      projeto = var.project_name
      dono    = "jose_rodrigues"
    }
  }
}

data "aws_caller_identity" "current" {}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr           = "10.0.0.0/16"
  environment        = var.environment
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  enable_nat_gateway = true

  tags = {
    Project     = var.project_name
    ManagedBy   = "Terraform"
    Environment = var.environment
  }
}

module "dynamodb_contabilidade" {
  source = "./modules/dynamodb"

  environment = var.environment
  table_name  = "contabilidade"
  hash_key    = "file_id"

  attributes = [
    { name = "file_id", type = "S" },
    { name = "file_name", type = "S" },
    { name = "num_lines", type = "N" },
    { name = "processed_at", type = "S" }
  ]

  index = [
    {
      name       = "FileNameIndex",
      hash_key   = "file_name",
      projection = "ALL"
    }
  ]

  global_secondary_indexes = [
    {
      name            = "ProcessedAtIndex"
      hash_key        = "processed_at"
      projection_type = "ALL"
    },
    {
      name            = "LinesIndex"
      hash_key        = "num_lines"
      projection_type = "KEYS_ONLY"
    }
  ]
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
  email_sns = var.email_sns
}

module "lambda" {
  source = "./modules/lambda"

  environment               = var.environment
  bucket_name               = module.s3.bucket_name
  sqs_queue_arn             = module.sqs.queue_arns["notify"]
  sns_topic_arn             = module.sns.sns_topic_arn
  dynamodb_table            = module.dynamodb_contabilidade.table_name
  create_notify_user_lambda = true
  create_event_source_mapping = true
  subnet_ids               =  module.vpc.subnet_ids
  security_group_ids        = [module.vpc.vpc_endpoint_sg_id]
  account_id               = data.aws_caller_identity.current.account_id
  region                   = var.aws_region
}
