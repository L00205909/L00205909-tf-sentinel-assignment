# Terraform Digital Sovereignty Assignment
Mirza AVCI - L00205909
## Overview

This project uses Terraform, HCP Terraform and HashiCorp Sentinel to plan a small AWS environment. The configuration defines an EC2 instance and a security group. All Terraform resources are in `Terraform/main.tf`.

## Policy controls

The Sentinel controls check that:

- Resources use the approved `eu-west-1` region.
- EC2 uses the approved `t3.micro` instance type.
- The root EBS volume is encrypted.
- IMDSv2 tokens are required.
- SSH access is restricted to a specific source IP range.

Each control has a separate Sentinel policy file for local testing. In the HCP Terraform Free workspace used for this assignment, the five controls were combined into one hard-mandatory managed policy for HCP plan evaluation.

## Testing

The five individual Sentinel policies were tested locally with Sentinel CLI using compliant mock data. HCP Terraform was used to evaluate one compliant plan and five non-compliant plans, each violating one control. The compliant plan passed; each non-compliant plan was blocked by the hard-mandatory policy. Screenshots and policy logs are included in `documentation/evidence/`.

The saved plan is `Terraform/tfplan`; its readable output is `Terraform/tfplan.txt`. All HCP runs were plan-only. No AWS resources were applied.

## Decision justification and limitations

Policy as Code applies infrastructure rules consistently before deployment, helping prevent plans that violate selected sovereignty and security requirements. Restricting AWS resources to `eu-west-1` supports regional placement, but does not prove that backups, replicas or administrative access remain within the same jurisdiction.

The AWS provider version is pinned and `.terraform.lock.hcl` is committed, supporting repeatable provider installation. These steps help with supply-chain integrity, but do not fully verify provider provenance. No external Terraform modules are used. Sentinel evaluates Terraform plans; it does not monitor runtime behaviour or changes made outside Terraform. Policies and dependency controls should be reviewed as cloud services and requirements evolve.

## LLM disclosure

OpenAI Codex, GPT-6, was used for guidance on Terraform configuration, Sentinel policy design and troubleshooting. Prompt summary: requests for step-by-step help building and testing the Terraform and Sentinel assignment. I selected the controls, made implementation decisions, ran the CLI and HCP tests, and reviewed the results.
