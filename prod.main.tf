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

module "my_vpc" {
  source      = "../modules/vpc"
  vpc_cidr    = "192.168.0.0/16"
  tenancy     = "default"
  vpc_id      = "${module.my_vpc.vpc_id}"
  subnet_cidr = "192.168.1.0/24"
}

module "my_ec2" {
  source        = "../modules/ec2instance"
  ec2_count     = 1
  ami_id        = "ami-02d1e544b84bf7502"
  instance_type = "t2.micro"
  subnet_id     = "${module.my_vpc.subnet_id}"
}