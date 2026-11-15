terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 6.64.0"
    }
  }
}

variable "aws_region" {
  description = "AWS region for this example"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "Approved EC2 instance type"
  type        = string
  default     = "t3.small"
}

variable "ssh_allowed_cidr" {
  description = "IP range allowed to connect over SSH"
  type        = string
  default     = "176.61.80.53/32"
}

provider "aws" {
  region = var.aws_region
}

data "aws_ssm_parameter" "al2023_ami" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_security_group" "demo" {
  name        = "demo-security-group"
  description = "Security group for the demo application"

  ingress {
    description = "Allow SSH from a restricted example IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_cidr]
  }

  egress {
    description = "Allow outbound HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project     = "Terraform Assignment"
    Environment = "demo"
  }
}

resource "aws_instance" "demo" {
  ami                    = data.aws_ssm_parameter.al2023_ami.value
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.demo.id]

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 8
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  tags = {
    Name        = "demo-ec2"
    Project     = "Terraform Assignment"
    Environment = "demo"
  }
}