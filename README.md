# Self-Hosted GitHub Actions Runner on AWS ECS

## Overview

This project sets up a **self-hosted GitHub Actions runner** on **AWS ECS (EC2 launch type)** to execute GitHub workflows. It allows for **scalable, cost-effective, and customizable CI/CD pipelines** while avoiding GitHub's hosted runner limitations.

## Features

✅ Run GitHub Actions on your own **ECS-hosted runners**  
✅ **Auto-scale** runners based on workload  
<!-- ✅ Secure GitHub authentication using **AWS SSM Parameter Store**   -->
<!-- ✅ **Persistent logs & monitoring** with CloudWatch   -->
<!-- ✅ Works with any repository using **self-hosted runners**   -->

<!-- ## Architecture

![Architecture Diagram](architecture.png) *(Have to add architecture diagram here once created)* -->

### How It Works

1. An ECS container registers itself as a GitHub Actions self-hosted runner.
2. When a GitHub workflow is triggered (`runs-on: self-hosted`), GitHub assigns it to the runner.
3. The ECS task executes CI/CD jobs inside the container.
4. If the runner stops, ECS restarts it to ensure availability.
5. Auto-scaling dynamically adjusts the number of runners.

## Tech Stack

- **AWS ECS (EC2 Launch Type)** – To run the GitHub Actions runner as a container.
- **IAM & SSM Parameter Store** – To securely store GitHub tokens.
- **AWS Auto Scaling** – To scale runners up/down as needed.
- **CloudWatch Logs** – To monitor runner activity.
