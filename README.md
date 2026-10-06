# azure-infra-foundation

Terraform for a small Northfield Office environment in Azure: resource group, virtual network, subnet, NSG, storage, Log Analytics. Network is a module. GitHub Actions runs `fmt` and `validate`. The default path does **not** deploy.

`terraform validate` does not prove a deploy. `terraform plan` needs Azure credentials and usually talks to Azure. This README states which checks are in the repo.

## Layout

```
terraform/                 root module
modules/network/           VNet, subnet, NSG
.github/workflows/validate.yml
docs/rbac.md
docs/cost-checklist.md
docs/monitor.md
docs/state.md
docs/cleanup.md
```

## Resources
- Resource group `nf-rg` in germanywestcentral
- VNet `10.40.0.0/16`, subnet `10.40.1.0/24`
- NSG: allow 443 from office CIDR, deny SSH from Internet
- Storage account Standard LRS, private container `evidence`, TLS 1.2
- Log Analytics, 30 day retention

## Checks that run without a subscription

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
terraform fmt -check -recursive
terraform init -backend=false
terraform validate
```

CI on `main` and pull requests runs the same three commands (`validate.yml`). That is **locally / CI validated**, not deployed.

## Shared responsibility
Microsoft runs the cloud fabric. You own identity, NSG rules, encryption settings, backup of blob data, and deleting billable resources.

## RBAC and traffic
See [docs/rbac.md](docs/rbac.md). Operators = Contributor on the RG. Readers = Reader. No subscription Owner for this lab.

## Remote state, monitor, restore
- [docs/state.md](docs/state.md) — blob backend, lock, cost of the state account
- [docs/monitor.md](docs/monitor.md) — diagnostic settings, blob soft-delete restore test
- [docs/cleanup.md](docs/cleanup.md) and [docs/cost-checklist.md](docs/cost-checklist.md)

## Apply
Needs an Azure subscription and explicit agreement on cost. Prefer GitHub OIDC, not a long-lived client secret.

```bash
az login
terraform init
terraform plan -out=tfplan
terraform apply tfplan
```

If you add a Linux VM, restrict SSH to `allowed_management_cidr`. Do not open 22 to the internet. Remove the VM, NIC, disk and public IP in the same change.

After apply, keep sanitized `terraform apply` output and `az resource list` in `evidence/`. Then destroy and keep `evidence/cleanup.txt`.

## Status of each part
| Part | In this repo | Live in Azure |
| --- | --- | --- |
| Terraform files, module, lock-after-init | yes | no until apply |
| `fmt` / `validate` / CI | yes | n/a |
| Role assignments | documented | no until `az role assignment` |
| Diagnostic settings, soft-delete restore | documented | no until apply |
| Remote state | example `backend.hcl` | no until you create the state account |
