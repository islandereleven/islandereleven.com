# Data Lake Stacks

This directory contains environment-specific Terraform roots for the Islander Eleven data lake.

- `staging` creates an isolated staging bucket for testing pipeline changes.
- `prod` manages the existing production data lake bucket.

The prod stack intentionally keeps the existing backend key from `infrastructure/s3/data_lake` so moving the Terraform files does not require a state migration.

For now, these stacks stay intentionally small: each environment manages only its data lake bucket and basic outputs. Once the staging flow is proven, these roots can be collapsed around a shared data-lake module and expanded with explicit bucket hardening as a separate change.
