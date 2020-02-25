#! /bin/env pwsh
Param (
    $username
)

function New-AzureLogin()
{
    $context = Get-AzContext

    if (!$context)
    {
        Connect-AzAccount
    }
}

function Write-Keyvault {
    Param (
        $secretName,
        $secretValue,
        $keyvaultName
    )
    $keyvault = Get-AzKeyVault -VaultName $KeyVaultName
    if (![String]::IsNullOrEmpty($keyvault) -eq $true) {
        Set-AzKeyVaultSecret -VaultName $KeyVaultName -Name $secretName -SecretValue (ConvertTo-SecureString -String $secretValue -AsPlainText -Force) |
            Out-Null
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

Write-Keyvault -keyvaultName $keyvaultName -secretName ("{0}-password" -f $appServiceName) -secretValue $grafanaPassword
Write-Keyvault -keyvaultName $keyvaultName -secretName ("{0}-address" -f $appServiceName) -secretValue ("https://{0}" -f $webApp.DefaultHostName)

Write-Host Grafana password is: $grafanaPassword
Write-Host Grafana address is: https://$($webApp.DefaultHostName)
