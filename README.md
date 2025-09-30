# ACR Helm Loginator

<img src="helmacrlogo.png" alt="alt text" style="width:30%;"/>

Utility PowerShell module to simplify logging into Azure Container Registry (ACR) with Helm.

## Features

- Log into an ACR with Helm using an Azure CLI access token.
- Optional parameter to log in and switch to the subscription that contains the ACR.
- Wraps the required `az` and `helm` commands into a single reusable function.

## Requirements

- [Docker Engine](https://docs.docker.com/engine/)  
  Required because Helm OCI support relies on the Docker credential store.
- [Azure CLI](https://learn.microsoft.com/cli/azure/install-azure-cli) (tested with 2.65.0+)  
- [Helm 3.x](https://helm.sh/docs/intro/install/) with OCI support enabled  

Verify dependencies:

```powershell
docker --version
az --version
helm version
```

## Installation

Clone the repository and import the module:

```powershell
git clone https://github.com/BesQpin/acr-helm-loginator.git
cd acr-helm-loginator
Import-Module ./helm-acrlogin.psd1 -Force
```

## Usage

### Log into an ACR

```powershell
Connect-HelmAcr -AcrName myAcr
```

### Log into an ACR in a specific subscription

```powershell
Connect-HelmAcr -AcrName myAcr -SubscriptionName 'mySubscription'
```

### Pull a chart

After logging in:

```powershell
helm pull oci://myAcr.azurecr.io/helm/mychart --version 1.0.0
```

### Inspect a chart

```powershell
helm show all ./mychart-1.0.0.tgz
```

## Notes

- The `--username` used by Helm login is always the placeholder GUID `00000000-0000-0000-0000-000000000000` when using an access token.
- The function automatically runs `az login` if you are not already authenticated.
