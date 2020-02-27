<#
        .SYNOPSIS
        Helper script for creating the Grafana webapp
        .PARAMETER Username
        Event Azure username assigned (tweaker-###) does not need the @...
        .EXAMPLE
        ./New-Grafana.ps1 -username tweaker-001
        .LINK
        https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Reporting/4_grafana.md
#>
Param (
    [Parameter(Mandatory)]
    [ValidatePattern({^tweaker-\d{3}$},ErrorMessage = "{0} is not a valid username")]
    [string]$username
)

$ErrorActionPreference = 'Stop'

function New-AzureLogin()
{
    $context = Get-AzContext

    if (!$context)
    {
        Connect-AzAccount
    }
}

New-AzureLogin

if ($username.contains('@')) {
    $username = $username.split('@')[0]
}

$location = "West Europe"
$sequence = $username.split('-')[-1]
$resourceGroupName = "lab001-weu-mgmt-twkrs-rsg-{0:000}" -f $sequence
$baseName = $resourceGroupName.split('-')[-3]

$appPlanName = '{0}-{1}-asp' -f $basename, $sequence
$appServiceName = '{0}-{1}-graf' -f $baseName, $sequence
$grafanaPassword = "P@ssW0rD!{0}" -f $sequence

$AppPlanParams = @{
    ResourceGroupName = $resourceGroupName
    ResourceName      = $appPlanName
    Location          = $location
    ResourceType      = "microsoft.web/serverfarms"
    kind              = "linux"
    Properties        = @{reserved = "true" }
    Sku               = @{name = "B1"; tier = "Basic"; size = "B1"; family = "B"; capacity = "1" }
}

$AzResource = Get-AzResource -Name $AppPlanParams.ResourceName `
    -ResourceGroupName $AppPlanParams.ResourceGroupName `
    -ResourceType $AppPlanParams.ResourceType `
    -ErrorAction SilentlyContinue

if ([String]::IsNullOrEmpty($AzResource) -eq $true) {
    New-AzResource @AppPlanParams -Force | Out-Null
}

$AppServiceParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $appServiceName
    AppServicePlan    = $appPlanName
}

$webapp = Get-AzWebApp -ResourceGroupName $appServiceParams.ResourceGroupName -Name $appServiceParams.Name -ErrorAction SilentlyContinue
if ([String]::IsNullOrEmpty($webapp) -eq $true) {
    $webApp = New-AzWebApp @AppServiceParams
}

$settings = @{
    GF_SERVER_ROOT_URL                          = "https://$($webApp.DefaultHostName)"
    GF_SECURITY_ADMIN_PASSWORD                  = "$grafanaPassword"
    GF_INSTALL_PLUGINS                          = "grafana-clock-panel,grafana-simple-json-datasource,grafana-azure-monitor-datasource"
    GF_AUTH_GENERIC_OAUTH_NAME                  = ""
    GF_AUTH_GENERIC_OAUTH_ENABLED               = "false"
}

$AppConfig = @{
    ResourceGroup      = $resourceGroupName
    Name               = $appServiceName
    AppSettings        = $settings
    ContainerImageName = "grafana/grafana"
}

Set-AzWebApp @AppConfig | Out-Null

Write-Host Grafana password is: $grafanaPassword
Write-Host Grafana address is: https://$($webApp.DefaultHostName)
