# Creating a S3 Bucket

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Configure the AWS Provider

provider "aws"{
region = "us-east-2"
      access_key = "AKIAR65ITFRYZR2NILJF"
      secret_key = "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"
}
# Creating s3 bucket

resource "aws_s3_bucket" "mybucket" {
  bucket = "bhargavi-27"
  acl    = "private"
tags = {
    Name        = "My bucket"
    Environment = "Dev"
}
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.mybucket.id
  versioning_configuration {
    status = "Suspended"
  }
}

#Enable Logging

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.mybucket.id
  acl    = "log-delivery-write"
}
resource "aws_s3_bucket_logging" "example" {
  bucket = aws_s3_bucket.mybucket.id

  target_bucket = aws_s3_bucket.mybucket.id
  target_prefix = "log/"
}

# Enable Server Side Encryption

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.mybucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

## Block public access

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls   = true
  block_public_policy = true
}

#lifecycle rule

resource "aws_s3_bucket_lifecycle_configuration" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    id = "rule-1"

    filter {
      prefix = "logs/"
    }
transition {
      days          = 30
      storage_class = "STANDARD_IA" # or "ONEZONE_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 90
    }
  status = "Enabled"
  }
}