variable "region" {
  description = "AWS region to deploy infrastructure"
  type = string
}

variable "tags" {
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