# Cost checklist

Azure budgets send alerts. They do not stop spend.

Before apply:
- [ ] Resource group in germanywestcentral
- [ ] Storage Standard LRS only
- [ ] Log Analytics 30 day retention
- [ ] No public IP unless a VM is explicitly added
- [ ] No SSH from Internet
- [ ] Budget alert on the subscription (e.g. 10 EUR)

After apply:
- [ ] `az resource list -g nf-rg -o table`
- [ ] Delete public IPs, NICs, disks, VM, storage, LAW, NSG, VNet, RG

```bash
az group delete -n nf-rg --yes --no-wait
az group show -n nf-rg   # should fail when gone
```

Remote state storage has its own account cost. See `docs/state.md`.
