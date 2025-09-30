@{
    RootModule        = 'helm-acrlogin.psm1'
    ModuleVersion     = '0.1.0'
    GUID              = 'a1f57c41-00c9-4a2b-bfdc-123456789abc'
    Author            = 'Your Name'
    CompanyName       = 'YourOrg'
    PowerShellVersion = '5.1'
    Description       = 'Utility functions for logging into Azure Container Registry with Helm.'
    FunctionsToExport = @('Connect-HelmAcr')
}
