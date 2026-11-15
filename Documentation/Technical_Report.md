# Technical Report

## Solution and policy decisions

1. **Repository and workspace:** A GitHub repository was created and connected to an HCP Terraform workspace using the `terraform` branch. AWS dynamic credentials were configured for the workspace.

2. **Terraform configuration:** The EC2 instance and security group configuration is contained in one `main.tf` file. Separate network, provider, variables and versions files were not created. The plan uses `eu-west-1` and a `t3.micro` instance, with an encrypted root EBS volume, required IMDSv2 tokens and SSH access restricted to a specific IP range. The AWS provider version is pinned and the lock file is committed.

3. **Sentinel policies:** Five controls were written as separate Sentinel files and tested locally with the Sentinel CLI and mock data from an HCP Terraform run. In the HCP Terraform Free workspace used for this project, the policy set was configured with one hard-mandatory managed policy; the five controls were therefore combined into one policy for HCP evaluation.

## Results

The compliant plan passed all five Sentinel checks. Five non-compliant plans each violated one control and were blocked by the hard-mandatory policy. All HCP runs were plan-only; no AWS resources were applied.

## Limitations and recommendations

The region rule does not by itself guarantee data sovereignty: it does not check backup locations, data replication or administrative access. Sentinel evaluates Terraform plans and does not monitor runtime behaviour or changes made outside Terraform. The pinned provider version and lock file support repeatable installations; future work could add explicit provider and module source, version and provenance controls. Policies should also be reviewed as cloud services and requirements evolve.

## LLM disclosure

OpenAI Codex, GPT-6, was used for guidance on Terraform configuration, Sentinel policy design and troubleshooting. Prompt summary: requests for step-by-step help building and testing the Terraform and Sentinel assignment. I selected the controls, made implementation decisions, ran the CLI and HCP tests, and reviewed the results.