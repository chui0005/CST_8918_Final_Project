# Infrastructure — Terraform

This directory contains all Terraform code for the CST8918 Final Project. It provisions the Azure infrastructure required to run the Remix Weather Application on AKS.

## What is covered

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
| ACR pull access | via `AcrPull` role on kubelet identity | via `AcrPull` role on kubelet identity |

---

### Azure Container Registry (`modules/acr`)

One ACR per environment, used to store the Remix Weather App Docker image.

| Setting | Test | Prod |
|---------|------|------|
| Registry name | `group9testacr` | `group9prodacr` |
| SKU | Standard | Standard |
| Admin account | Disabled | Disabled |
| AKS pull access | `AcrPull` role assigned to AKS kubelet identity | `AcrPull` role assigned to AKS kubelet identity |

---

### Azure Cache for Redis (`modules/redis`)

One Redis Cache per environment, used by the weather app to cache API responses.

| Setting | Test | Prod |
|---------|------|------|
| Instance name | `test-redis-9` | `prod-redis-9` |
| SKU | Basic C0 | Standard C1 |
| Non-SSL port | Disabled | Disabled |
| Minimum TLS | 1.2 | 1.2 |

---

### Kubernetes App Deployment (`modules/app`)

Deploys the Remix Weather Application into a dedicated namespace on each AKS cluster.

| Resource | Test | Prod |
|----------|------|------|
| Namespace | `weather-test` | `weather-prod` |
| Deployment | `weather-app` | `weather-app` |
| Replicas | 1 | 2 |
| Service | LoadBalancer (port 80 → 3000) | LoadBalancer (port 80 → 3000) |
| Image | `group9testacr.azurecr.io/weather:<tag>` | `group9prodacr.azurecr.io/weather:<tag>` |
| Secrets | Kubernetes Secret (`WEATHER_API_KEY`, `REDIS_PASSWORD`) | Kubernetes Secret (`WEATHER_API_KEY`, `REDIS_PASSWORD`) |
| Health probes | Readiness + Liveness on `/` port 3000 | Readiness + Liveness on `/` port 3000 |
| Resource limits | 500m CPU / 512Mi memory | 500m CPU / 512Mi memory |

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
│   ├── aks/                 # AKS cluster with optional autoscaling and ACR pull access
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── acr/                 # Azure Container Registry
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── redis/               # Azure Cache for Redis
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── app/                 # Kubernetes Namespace, Secret, Deployment, and Service
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

## Remaining work

The following will be added in separate pull requests:

- GitHub Actions workflows (static analysis, plan, apply, Docker build, app deploy)
- Azure federated identity setup for GitHub Actions OIDC

## Usage

> **Before running any environment**, complete the bootstrap step to create the remote backend. See [bootstrap/README.md](bootstrap/README.md).

### Supplying the OpenWeather API key

The `weather_api_key` variable is sensitive and must **never** be committed to the repository. Supply it at apply time using one of:

```bash
# Option A — environment variable (recommended for CI)
export TF_VAR_weather_api_key="your-key-here"

# Option B — gitignored local override file
echo 'weather_api_key = "your-key-here"' > terraform.tfvars.local
```

### Applying an environment

```bash
# Validate (no backend required)
cd environments/test
terraform init -backend=false
terraform validate

# Full init and plan (requires backend to be bootstrapped)
terraform init
terraform plan

# Apply
terraform apply
```

> **Note:** After a fresh `terraform apply` that creates a new AKS cluster, run the following before applying the app module:
> ```bash
> az aks get-credentials --resource-group <rg-name> --name <cluster-name>
> ```
> This updates `~/.kube/config` so the Kubernetes provider can authenticate to the new cluster.
