function Connect-HelmAcr {
    <#
    .SYNOPSIS
        Logs into Azure Container Registry with Helm using an access token.

    .PARAMETER AcrName
        The name of the Azure Container Registry (without .azurecr.io).

    .PARAMETER SubscriptionName
        Optional. The Azure subscription that contains the ACR.
        If provided, will attempt to log into that subscription before retrieving the ACR token.

    .EXAMPLE
        Connect-HelmAcr -AcrName jgmseaprdssvacr

    .EXAMPLE
        Connect-HelmAcr -AcrName jgmseaprdssvacr -SubscriptionName 00000000-0000-0000-0000-000000000000
    #>

    param(
        [Parameter(Mandatory = $true)]
        [string]$AcrName,

        [Parameter(Mandatory = $false)]
        [string]$SubscriptionName
    )

    # Ensure Azure CLI is logged in
    Write-Verbose "Ensuring Azure CLI login..."
    $azLoggedIn = $false
    try {
        az account show 1>$null 2>$null
        if ($LASTEXITCODE -eq 0) { $azLoggedIn = $true }
    } catch {}

    if (-not $azLoggedIn) {
        if ($PSBoundParameters.ContainsKey('SubscriptionName')) {
            Write-Host "🔑 Logging into Azure subscription $SubscriptionName..."
            az login --subscription $SubscriptionName | Out-Null
        } else {
            Write-Host "🔑 Logging into Azure..."
            az login | Out-Null
        }
    }

    # Set subscription if provided
    if ($PSBoundParameters.ContainsKey('SubscriptionName')) {
        Write-Host "📌 Setting Azure subscription context to $SubscriptionName..."
        az account set --subscription $SubscriptionName
    }

    # Get fresh token for ACR
    Write-Verbose "Getting ACR token..."
    $token = az acr login --name $AcrName --expose-token --output tsv --query accessToken --only-show-errors

    if (-not $token) {
        throw "Failed to retrieve access token for ACR $AcrName"
    }

    # Perform Helm registry login
    Write-Verbose "Logging into Helm registry..."
    helm registry login "$AcrName.azurecr.io" `
        --username 00000000-0000-0000-0000-000000000000 `
        --password $token

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Logged into Helm registry: $AcrName.azurecr.io"
    } else {
        throw "Helm registry login failed for $AcrName.azurecr.io"
    }
}

function Disconnect-HelmAcr {
    <#
    .SYNOPSIS
        Logs out of a Helm registry for an Azure Container Registry.

    .PARAMETER AcrName
        The name of the Azure Container Registry (without .azurecr.io).

    .EXAMPLE
        Disconnect-HelmAcr -AcrName jgmseaprdssvacr
    #>

    param(
        [Parameter(Mandatory = $true)]
        [string]$AcrName
    )

    Write-Verbose "Logging out of Helm registry..."
    helm registry logout "$AcrName.azurecr.io"

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Logged out of Helm registry: $AcrName.azurecr.io"
    } else {
        throw "Helm registry logout failed for $AcrName.azurecr.io"
    }

    # Optional: also log out from Docker to fully clear creds
    try {
        docker logout "$AcrName.azurecr.io" | Out-Null
        Write-Verbose "Also logged out of Docker registry: $AcrName.azurecr.io"
    } catch {
        Write-Verbose "Docker logout skipped (Docker may not be running)."
    }
}
