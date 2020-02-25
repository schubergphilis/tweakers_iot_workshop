#! /bin/env pwsh
Param (
    $username,
    $JobName,
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

$Sequence = $username.split('-')[-1]
$IotHubNumber = [Math]::Round([Math]::Ceiling($sequence / 5))
$IotHubName = 'twkrs-{0:000}-iot-hub' -f $IotHubNumber
$IotHubResourceGroupName =  'lab001-weu-mgmt-iot-rsg-{0:000}' -f $IotHubNumber
$ResourceGroupName =  'lab001-weu-mgmt-twkrs-rsg-{0:000}' -f $IotHubNumber

$JobObject = (Get-Content (Join-Path $PsScriptRoot 'Job.json') | ConvertFrom-Json)

$IotHubParams = @{
    ResourceGroupName = $IotHubResourceGroupName
    Name              = $IotHubName
}
$AzIotHubPrimaryKey = (Get-AzIotHubKey @IotHubParams -KeyName "iothubowner").PrimaryKey

$InputObject = (Get-Content (Join-Path $PsScriptRoot 'InputDataSourceIotHubs.json') | ConvertFrom-Json)
$InputObject.properties.datasource.properties.iotHubNamespace = $IotHubName
$InputObject.properties.datasource.properties.sharedAccessPolicyKey = $AzIotHubPrimaryKey
$InputObject.properties.datasource.properties.consumerGroupName = $consumerGroupName

$JobObject.properties.inputs += $InputObject

$TempInputFile = New-TemporaryFile
$JobObject | ConvertTo-Json -Depth 25 -Compress > $TempInputFile

New-AzStreamAnalyticsJob -ResourceGroupName $ResourceGroupName -File $TempInputFile -Name $JobName -Force
Remove-Item $TempInputFile

