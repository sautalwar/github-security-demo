# ============================================================
# Terraform Infrastructure - Demo for IaC Security Scanning
# Contains intentional misconfigurations for Checkov to detect
# ============================================================

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name"
  default     = "demo"
}

# --- VPC ---
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true  # DEMO: Checkov will flag this
  availability_zone       = "${var.aws_region}a"

  tags = {
    Name = "${var.environment}-public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "${var.aws_region}b"

  tags = {
    Name = "${var.environment}-private-subnet"
  }
}

# --- S3 Bucket (intentional misconfigurations for scanning demo) ---
resource "aws_s3_bucket" "app_data" {
  bucket = "${var.environment}-app-data-bucket"
  # DEMO: Missing versioning - Checkov CKV_AWS_21
  # DEMO: Missing encryption - Checkov CKV_AWS_19
  # DEMO: Missing logging - Checkov CKV_AWS_18

  tags = {
    Name        = "${var.environment}-app-data"
    Environment = var.environment
  }
}

# DEMO: Public access not explicitly blocked - Checkov CKV_AWS_53-56
resource "aws_s3_bucket_public_access_block" "app_data" {
  bucket = aws_s3_bucket.app_data.id

  block_public_acls       = false  # DEMO: Should be true
  block_public_policy     = false  # DEMO: Should be true
  ignore_public_acls      = false  # DEMO: Should be true
  restrict_public_buckets = false  # DEMO: Should be true
}

# --- Security Group (intentional overly permissive rules) ---
resource "aws_security_group" "app" {
  name        = "${var.environment}-app-sg"
  description = "Security group for application"
  vpc_id      = aws_vpc.main.id

  # DEMO: Overly permissive ingress - Checkov CKV_AWS_24
  ingress {
    description = "Allow all SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # DEMO: Should be restricted
  }

  # DEMO: Wide open HTTPS
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow app port"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # DEMO: Should be restricted to VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-app-sg"
  }
}

# --- RDS Database (intentional misconfigurations) ---
resource "aws_db_instance" "app_db" {
  identifier     = "${var.environment}-app-db"
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "appdb"
  username = "admin"
  password = "DemoPassword123!"  # DEMO: Hardcoded password - Checkov will flag

  publicly_accessible    = true   # DEMO: Should be false - Checkov CKV_AWS_17
  storage_encrypted      = false  # DEMO: Should be true - Checkov CKV_AWS_16
  skip_final_snapshot    = true
  deletion_protection    = false  # DEMO: Should be true for production

  vpc_security_group_ids = [aws_security_group.app.id]
  db_subnet_group_name   = aws_db_subnet_group.app.name

  tags = {
    Name        = "${var.environment}-app-db"
    Environment = var.environment
  }
}

resource "aws_db_subnet_group" "app" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = [aws_subnet.public.id, aws_subnet.private.id]

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

# --- ECS Cluster ---
resource "aws_ecs_cluster" "app" {
  name = "${var.environment}-app-cluster"

  # DEMO: Missing container insights - Checkov CKV_AWS_65
  setting {
    name  = "containerInsights"
    value = "disabled"  # DEMO: Should be "enabled"
  }

  tags = {
    Name        = "${var.environment}-app-cluster"
    Environment = var.environment
  }
}

# --- CloudWatch Log Group ---
resource "aws_cloudwatch_log_group" "app" {
  name              = "/ecs/${var.environment}-app"
  retention_in_days = 7  # DEMO: Short retention

  # DEMO: Missing KMS encryption - Checkov CKV_AWS_158

  tags = {
    Name        = "${var.environment}-app-logs"
    Environment = var.environment
  }
}

# --- Outputs ---
output "vpc_id" {
  value = aws_vpc.main.id
}

output "app_security_group_id" {
  value = aws_security_group.app.id
}

output "db_endpoint" {
  value     = aws_db_instance.app_db.endpoint
  sensitive = true
}
