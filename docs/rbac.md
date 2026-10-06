# RBAC and traffic

## Roles
| Identity | Scope | Role | Why |
| --- | --- | --- | --- |
| Platform operators group | Resource group `nf-rg` | Contributor | change lab resources |
| Readers group | Resource group `nf-rg` | Reader | tickets, no change |
| CI workload identity | Resource group `nf-rg` | Contributor | `terraform plan` / apply from GitHub OIDC only |
| Nobody | Subscription | Owner | too wide for this lab |

Assign in Azure after login. Terraform can take object IDs later; they are not hardcoded here because they belong to a tenant.

```bash
az role assignment create \
  --assignee-object-id <operators-group-oid> \
  --role Contributor \
  --scope /subscriptions/<sub>/resourceGroups/nf-rg
```

## Permitted traffic
NSG `nf-nsg-app`:
- Allow TCP 443 from `10.20.0.0/24` (office)
- Deny TCP 22 from Internet
- Default Azure rules remain for VNet and load balancer

SSH to a VM, if you add one, is only from the office CIDR. Not `0.0.0.0/0`.
