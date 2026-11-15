The compliant Terraform plan uses the approved eu-west-1 region and t3.micro instance type. It encrypts the root EBS volume, requires IMDSv2 tokens, and restricts SSH access to a specific IP range. Expected result: all five Sentinel rules pass.

Five non-compliant plans each violate one control: use an unapproved region, use an unapproved instance type, disable root volume encryption, make IMDSv2 tokens optional, or allow SSH from 0.0.0.0/0. Expected result: the corresponding Sentinel rule fails and the hard-mandatory policy blocks the plan from being applied.

- **Region:** Changed `aws_region` from `eu-west-1` to `us-east-1`.
- **Encryption:** Changed the root volume setting from `encrypted = true` to `encrypted = false`.
- **Instance type:** Changed `instance_type` from `t3.micro` to an unapproved type (`t3.small`).
- **SSH access:** Changed `ssh_allowed_cidr` to `0.0.0.0/0`.
- **Metadata:** Changed `http_tokens` from `"required"` to `"optional"`.

All HCP Terraform runs were plan-only; no AWS resources were applied.