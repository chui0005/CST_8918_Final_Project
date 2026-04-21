# CST8918 IaC Final Project — Remix Weather App on Azure

This project deploys the Remix Weather Application to Azure Kubernetes Service (AKS) using Terraform for infrastructure as code and GitHub Actions for CI/CD automation.

## Team Members

| Name | GitHub |
|------|--------|
| Bryan Chuinkam | [@chui0005](https://github.com/chui0005) | 
| Trevor Kutto | [@Sighopss](https://github.com/Sighopss) |
| Perpetue Djone  | [@DjoPerp](https://github.com/DjoPerp) |
| Sandrarochel Nyabengmineme | [@sandra-rochelle-nyabeng-mineme](https://github.com/sandra-rochelle-nyabeng-mineme) |

## Project Overview

The infrastructure is managed with Terraform and organized into the following modules:

- **bootstrap** — Azure Blob Storage backend for Terraform remote state
- **network** — Virtual network with prod/test/dev/admin subnets
- **aks** — Azure Kubernetes Service clusters (test and prod)
- **acr** — Azure Container Registry for Docker images
- **redis** — Azure Cache for Redis (test and prod)
- **app** — Kubernetes deployment and service for the weather app

Two environments are provisioned: **test** and **prod**, each with their own AKS cluster and Redis instance. A shared ACR is created in the test stack and reused by prod.

## GitHub Actions Workflows

| Workflow | Trigger |
|----------|---------|
| Terraform static analysis (fmt, validate, tfsec) | Push to any branch |
| Terraform plan + tflint | Pull request to `main` |
| Terraform apply | Push to `main` (merged PR) |
| Docker build & push to ACR | PR to `main` (app code changes) |
| Deploy to AKS test | PR to `main` (app code changes) |
| Deploy to AKS prod | Push to `main` (app code changes) |

## Infrastructure Setup

### Prerequisites

- Azure CLI (`az login`)
- Terraform >= 1.9.0
- An Azure subscription with Contributor access

### 1. Bootstrap (one-time)

Creates the Azure Storage account used as the Terraform remote backend.

```sh
cd infrastructure/bootstrap
terraform init
terraform apply
```

### 2. GitHub Identity (one-time)

Creates the Azure federated identity for GitHub Actions OIDC authentication.

```sh
cd infrastructure/github-identity
terraform init
terraform apply -var="group_number=<your-group-number>"
```

### 3. Test Environment

```sh
cd infrastructure/environments/test
terraform init
terraform apply \
  -var="group_number=<your-group-number>" \
  -var="weather_api_key=<your-openweather-api-key>"
```

### 4. Prod Environment

```sh
cd infrastructure/environments/prod
terraform init
terraform apply \
  -var="group_number=<your-group-number>" \
  -var="weather_api_key=<your-openweather-api-key>"
```

## Application Local Setup

### Requirements

- Node.js 18+
- An OpenWeather API key

### Steps

```sh
npm install
cp .env.example .env
# Add WEATHER_API_KEY to .env
npm run dev
```

Open [http://localhost:3000](http://localhost:3000).

## Available Scripts

- `npm run dev` — start local dev server
- `npm run build` — build for production
- `npm run start` — run production build locally
- `npm run lint` — run ESLint
- `npm run typecheck` — run TypeScript checks

## Docker

```sh
docker build -t remix-weather .
docker run --rm -p 3000:3000 --env-file .env remix-weather
```
