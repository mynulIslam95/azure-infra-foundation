# Remote state

Local state is the default in this repo so `terraform validate` does not need Azure.

When you enable remote state, use a **separate** storage account, container `tfstate`, blob key `northfield.tfstate`. Lock with the Azure blob lease (azurerm backend does this).

`terraform/backend.hcl.example`:

```
resource_group_name  = "nf-tfstate-rg"
storage_account_name = "nftfstateXXXX"
container_name       = "tfstate"
key                  = "northfield.tfstate"
```

```bash
terraform init -backend-config=backend.hcl
```

Cost: the state account is billed even when the lab RG is empty. Permissions: only the operator identity and the GitHub OIDC app. No anonymous access.
