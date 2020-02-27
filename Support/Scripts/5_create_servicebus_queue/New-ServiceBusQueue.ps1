<#
        .SYNOPSIS
        Helper script for creating the Service bus queue
        .PARAMETER Username
        Event Azure username assigned (tweaker-###) does not need the @...
        .EXAMPLE
        ./New-ServiceBusQueue.ps1 -username tweaker-001
        .LINK
        https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Actioning/5_create_servicebus_queue.md
#>
Param (
    [Parameter(Mandatory)]
    [ValidatePattern({^tweaker-\d{3}$},ErrorMessage = "{0} is not a valid username")]
    [string]$username
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
