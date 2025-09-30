@{
    RootModule        = 'helm-acrlogin.psm1'
    ModuleVersion     = '1.1.0'
    GUID              = 'a1f57c41-00c9-4a2b-bfdc-123456789abc'
    Author            = 'Peter Williams'
    PowerShellVersion = '5.1'
    Description       = 'Utility functions for logging into Azure Container Registry with Helm.'
    FunctionsToExport = @('Connect-HelmAcr', 'Disconnect-HelmAcr')
}
