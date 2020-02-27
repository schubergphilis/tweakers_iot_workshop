<#
        .SYNOPSIS
        Helper script for IoT Hub Configuration.
        .PARAMETER Username
        Event Azure username assigned (tweaker-###) does not need the @...
        .PARAMETER consumerGroupName
        Name of the IOT EventHub ConsumerGroup that you want to add.
        .EXAMPLE
        ./New-IotConsumerGroup.ps1 -username tweaker-001 -consumerGroupName myConsumerGroup
        .LINK
        https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Reporting/1_iothub.md
#>
Param (
    [Parameter(Mandatory)]
    [ValidatePattern({^tweaker-\d{3}$},ErrorMessage = "{0} is not a valid username")]
    [string]$username,
    [Parameter(Mandatory)]
    [string]$consumerGroupName
)

$ErrorActionPreference = 'Stop'

function New-AzureLogin() {
    $context = Get-AzContext
    if (!$context) {
        Connect-AzAccount
    }
}

New-AzureLogin

if ($username.contains('@')) {
    $username = $username.split('@')[0]
}

$sequence = $username.split('-')[1]
$IotHubNumer = [Math]::Round([Math]::Ceiling($sequence / 5))
$resourceGroupName = 'lab001-weu-mgmt-iot-rsg-{0:000}' -f $IotHubNumer
$IotHubName = 'twkrs-{0:000}-iot-hub' -f $IotHubNumer

$IotHubParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $IotHubName
}

$AzIotHub = Get-AzIotHub @IotHubParams
if ([String]::IsNullOrEmpty($AzIotHub) -eq $false) {
    $IotHubEventHubConsumerGroup = Add-AzIotHubEventHubConsumerGroup -ResourceGroupName $resourceGroupName -Name $IotHubName `
        -EventHubConsumerGroupName $consumerGroupName
}

$ConsumerGroup = $IotHubEventHubConsumerGroup | Where-Object { $_.Name -eq $consumerGroupName }

Write-Host Consumergroup $ConsumerGroup.Name created on $IotHubName

