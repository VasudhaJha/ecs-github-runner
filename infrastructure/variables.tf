variable "region" {
  description = "AWS region to deploy infrastructure"
  type = string
}

variable "common_tags" {
  description = "Tags for all AWS resources"
  type = map(string)
}

variable "remote_backend_name" {
  description = "Name of the S3 bucket which serves as the remote backend"
  type = string
}

variable "state_locking_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type = string
}

variable "vpc_cidr_block" {
  description = "CIDR range for the VPC"
  type = string
}

variable "private_subnet_offset" {
  description = "Offset to start CIDR index for private subnets"
  type        = number
}