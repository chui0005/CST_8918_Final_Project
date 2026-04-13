# Bootstrap — Terraform Remote Backend

This directory is a **one-time setup** that creates the Azure Storage Account used as the Terraform remote backend for all environments. It uses a local state file and is never managed by the remote backend itself.

## Prerequisites

- Azure CLI installed and authenticated (`az login`)
- Contributor or Owner role on the target Azure subscription
- Terraform >= 1.9.0

## Steps

### 1. Check storage account name availability

Storage account names must be globally unique across all of Azure. Verify the name before applying:

```bash
az storage account check-name --name cst8918tfstate9
```

If the name is taken, edit `main.tf` and append a few random characters (e.g., `cst8918tfstate9ab`).

### 2. Initialize and apply

```bash
cd infrastructure/bootstrap
terraform init
terraform apply
```

### 3. Note the outputs

After a successful apply, Terraform will print:

```
storage_account_name = "cst8918tfstate9"
container_name       = "tfstate"
resource_group_name  = "rg-cst8918-tfstate"
```

### 4. Update environment backend configs

Copy the output values into `backend.tf` in both environment directories:

- `infrastructure/environments/test/backend.tf`
- `infrastructure/environments/prod/backend.tf`

Replace the placeholder comment with the actual `storage_account_name`.

### 5. Grant GitHub Actions access to the storage account

After creating the storage account, assign the `Storage Blob Data Contributor` role to the GitHub Actions managed identity/app registration:

```bash
az role assignment create \
  --assignee <GITHUB_ACTIONS_CLIENT_ID> \
  --role "Storage Blob Data Contributor" \
  --scope $(terraform output -raw storage_account_id)
```

## Notes

- The local `terraform.tfstate` file produced here is kept in local directory. **Do not delete it** — it tracks the backend storage resources themselves.
- The bootstrap state file should be committed to the repository (it contains no secrets) or stored securely by a team admin.
- Do not run `terraform destroy` in this directory unless you intend to delete all Terraform state for all environments.
