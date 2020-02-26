#! /bin/env pwsh
Param (
    $username
)

$ErrorActionPreference = 'Stop'

function New-AzureLogin() {
    $context = Get-AzContext
    if (!$context) {
        Connect-AzAccount
    }
}

New-AzureLogin

$location = "West Europe"

if ($username.contains('@')) {
    $username = $username.split('@')[0]
}

$Sequence = $username.split('-')[-1]
$ResourceGroupName =  'lab001-weu-mgmt-twkrs-rsg-{0:000}' -f $Sequence

Set-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings "true"

$ServiceBusNamespace = New-AzServiceBusNamespace -ResourceGroupName $ResourceGroupName -NamespaceName $username -Location $location

New-AzServiceBusQueue -ResourceGroupName $ResourceGroupName -NamespaceName $username `
    -Name "pouring_events" -EnablePartitioning $False | Out-Null

Remove-Item Env:\SuppressAzurePowerShellBreakingChangeWarnings

Write-Host ServiceBus endpoint is: $ServiceBusNamespace.ServiceBusEndpoint
