# Cleanup

```bash
terraform destroy -auto-approve
az group list --query "[?starts_with(name, 'nf')]" -o table
az network public-ip list -g nf-rg -o table
az disk list -g nf-rg -o table
```

If destroy fails, delete leftover disks and public IPs, then the resource group.

Record the empty `az resource list -g nf-rg` output in `evidence/cleanup.txt`.
