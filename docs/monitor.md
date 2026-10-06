# Azure Monitor

Log Analytics workspace `nf-law` is in `terraform/main.tf`. Diagnostic settings for the storage account are added after the first successful apply (needs the workspace resource ID from state).

```bash
az monitor diagnostic-settings create \
  --resource <storage-id> \
  --name nf-storage-diag \
  --workspace <law-id> \
  --logs '[{"category":"StorageRead","enabled":true}]'
```

Restore of a blob: upload a test file, delete it, restore from soft-delete after you enable it on the account. Record the test in `evidence/restore.txt`. Soft-delete is not on until you turn it on in the portal or:

```bash
az storage account blob-service-properties update \
  --account-name <name> \
  --enable-delete-retention true \
  --delete-retention-days 7
```
