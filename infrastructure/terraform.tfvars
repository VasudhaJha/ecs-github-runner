region = "ap-south-1"
tags = {
  "Project"   = "ecs-github-runner"
  "ManagedBy" = "Terraform"
}

remote_backend_name = "self-hosted-github-runner-terraform-state"
state_locking_table_name = "self-hosted-github-runner-terraform-state-lock"