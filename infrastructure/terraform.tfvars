region = "ap-south-1"
common_tags = {
  "Project"   = "ecs-github-runner"
  "ManagedBy" = "Terraform"
}

remote_backend_name = "self-hosted-github-runner-terraform-state"
state_locking_table_name = "self-hosted-github-runner-terraform-state-lock"

vpc_cidr_block = "10.0.0.0/16"
private_subnet_offset = 10