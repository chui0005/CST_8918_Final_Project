# Infrastructure — Terraform

This directory contains all Terraform code for the CST8918 Final Project. It provisions the core Azure infrastructure required to run the Remix Weather Application on AKS.

## What is currently covered

### Terraform Remote Backend

Managed by the `modules/backend` module, bootstrapped once via `bootstrap/`.

- **Azure Resource Group** — `rg-cst8918-tfstate`
- **Azure Storage Account** — stores all Terraform state files
- **Blob Container** — `tfstate`, with versioning enabled and no public access

See [bootstrap/README.md](bootstrap/README.md) for one-time setup instructions.

---

### Base Network (`modules/network`)

- **Azure Resource Group** — `cst8918-final-project-group-9`
- **Virtual Network** — `10.0.0.0/14` address space
- **4 Subnets**:

  | Subnet | CIDR |
  |--------|------|
  | `subnet-prod` | `10.0.0.0/16` |
  | `subnet-test` | `10.1.0.0/16` |
  | `subnet-dev` | `10.2.0.0/16` |
  | `subnet-admin` | `10.3.0.0/16` |

---

### AKS Clusters (`modules/aks`)

Two AKS clusters are provisioned — one per environment.

| Setting | Test | Prod |
|---------|------|------|
| Cluster name | `aks-cst8918-test-group-9` | `aks-cst8918-prod-group-9` |
| Kubernetes version | 1.32 | 1.32 |
| VM size | Standard_B2s | Standard_B2s |
| Node count | 1 (fixed) | 1–3 (autoscaling) |
| Subnet | `subnet-test` | `subnet-prod` |
| Identity | SystemAssigned | SystemAssigned |
| Network plugin | Azure CNI | Azure CNI |
| Upgrade channel | patch | patch |

---

## Directory Structure

```
infrastructure/
├── bootstrap/               # One-time local apply to create remote backend storage
│   ├── main.tf
│   └── README.md
├── modules/
│   ├── backend/             # Azure Blob Storage backend resources
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network/             # Resource group, VNet, and subnets
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── aks/                 # AKS cluster with optional autoscaling
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── environments/
│   ├── test/                # Test environment root configuration
│   │   ├── main.tf
│   │   ├── backend.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/                # Prod environment root configuration
│       ├── main.tf
│       ├── backend.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
└── .tflint.hcl              # tflint configuration for CI lint checks
```

## What is not yet covered

The following resources are managed by other team members and will be added in separate pull requests:

- Azure Container Registry (ACR)
- Redis Cache (Azure Cache for Redis) for test and prod
- Kubernetes Deployment and Service manifests for the Remix Weather App
- GitHub Actions workflows (static analysis, plan, apply, Docker build, app deploy)
- Azure federated identity setup for GitHub Actions OIDC

## Usage

> **Before running any environment**, complete the bootstrap step to create the remote backend. See [bootstrap/README.md](bootstrap/README.md).

```bash
# Validate an environment (no backend required)
cd environments/test
terraform init -backend=false
terraform validate

# Full init and plan (requires backend to be bootstrapped)
terraform init
terraform plan

# Apply
terraform apply
```
