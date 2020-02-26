<#
        .SYNOPSIS
        Helper script to create an Azure Stream Analytics Job
        .PARAMETER Username
        Event Azure username assigned (tweaker-###) does not need the @...
        .PARAMETER JobName
        Specifies the name of the Azure Stream Analytics job to create.
        .PARAMETER consumerGroupName
        Name of the IOT EventHub ConsumerGroup that you want connect to.
        .EXAMPLE
        ./New-StreamAnalyticsJob.ps1 -username tweaker-001 -JobName BeerJob -consumerGroupName myConsumerGroup
        .LINK
        https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Reporting/3_azure_stream_analytics.md#step-3-create-an-azure-stream-analytics-job
#>
Param (
    [Parameter(Mandatory)]
    [ValidatePattern({^tweaker-\d{3}$},ErrorMessage = "{0} is not a valid username")]
    [string]$username,
    [Parameter(Mandatory)]
    [string]$JobName,
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

$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

if ($username.contains('@')) {
    $username = $username.split('@')[0]
}

$Sequence = $username.split('-')[-1]
$IotHubNumber = [Math]::Round([Math]::Ceiling($sequence / 5))
$IotHubName = 'twkrs-{0:000}-iot-hub' -f $IotHubNumber
$IotHubResourceGroupName =  'lab001-weu-mgmt-iot-rsg-{0:000}' -f $IotHubNumber
$ResourceGroupName =  'lab001-weu-mgmt-twkrs-rsg-{0:000}' -f $IotHubNumber

$JobObject = (Get-Content (Join-Path $scriptDirectory 'Job.json') | ConvertFrom-Json)

$IotHubParams = @{
    ResourceGroupName = $IotHubResourceGroupName
    Name              = $IotHubName
}
$AzIotHubPrimaryKey = (Get-AzIotHubKey @IotHubParams -KeyName "iothubowner").PrimaryKey

$InputObject = (Get-Content (Join-Path $scriptDirectory 'InputDataSourceIotHubs.json') | ConvertFrom-Json)
$InputObject.properties.datasource.properties.iotHubNamespace = $IotHubName
$InputObject.properties.datasource.properties.sharedAccessPolicyKey = $AzIotHubPrimaryKey
$InputObject.properties.datasource.properties.consumerGroupName = $consumerGroupName

$JobObject.properties.inputs += $InputObject

$TempInputFile = New-TemporaryFile
$JobObject | ConvertTo-Json -Depth 25 -Compress > $TempInputFile

New-AzStreamAnalyticsJob -ResourceGroupName $ResourceGroupName -File $TempInputFile -Name $JobName -Force
Remove-Item $TempInputFile

