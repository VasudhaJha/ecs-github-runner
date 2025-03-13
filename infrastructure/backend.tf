# Create S3 bucket with versioning enabled to act as the remote backend

resource "aws_s3_bucket" "remote_backend" {
  bucket = var.remote_backend_name
  tags = var.tags
}

resource "aws_s3_bucket_versioning" "remote_backend" {
  bucket = aws_s3_bucket.remote_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create dynamodb table for state locking
resource "aws_dynamodb_table" "state_locking_table" {
  name = var.state_locking_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

}

