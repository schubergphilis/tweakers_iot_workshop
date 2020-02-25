#! /bin/env pwsh
Param (
    $username,
    $consumerGroupName
)

function New-AzureLogin() {
    $context = Get-AzContext
    if (!$context) {
        Connect-AzAccount
    }
}

New-AzureLogin

$location = "West Europe"

$sequence = $username.split('-')[1]
$IotHubNumer = [Math]::Round([Math]::Ceiling($sequence / 5))
$resourceGroupName =  'lab001-weu-mgmt-iot-rsg-{0:000}' -f $IotHubNumer
$IotHubName = 'twkrs-{0:000}-iot-hub' -f $IotHubNumer

$IotHubParams = @{
    ResourceGroupName = $resourceGroupName
    Name              = $IotHubName
}

$AzIotHub = Get-AzIotHub @IotHubParams
if ([String]::IsNullOrEmpty($AzIotHub) -eq $false) {
        Add-AzIotHubEventHubConsumerGroup -ResourceGroupName $resourceGroupName -Name $IotHubName `
            -EventHubConsumerGroupName $consumerGroupName | Out-null
}