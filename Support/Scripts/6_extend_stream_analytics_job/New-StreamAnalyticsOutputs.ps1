<#
        .SYNOPSIS
        Helper script for updating the Azure Stream Analytics Job
        .PARAMETER Username
        Event Azure username assigned (tweaker-###) does not need the @...
        .EXAMPLE
        ./New-StreamAnalyticsOutputs -username tweaker-001
        .EXAMPLE
        ./New-StreamAnalyticsOutputs -username tweaker-001 -jobname Beerjob
        .EXAMPLE
        ./New-StreamAnalyticsOutputs -username tweaker-001 -serviceBusNamespace tweaker-001
        .LINK
        https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Actioning/6_extend_stream_analytics_job.md
#>
Param (
    [Parameter(Mandatory)]
    [ValidatePattern({^tweaker-\d{3}$},ErrorMessage = "{0} is not a valid username")]
    [string]$username,
    [Parameter(Mandatory=$false)]
    [string]$JobName = 'BeerJob',
    [Parameter(Mandatory=$false)]
    [string]$sqluser = $userName,
    [Parameter(Mandatory)]
    [string]$sqlpassword,
    [Parameter(Mandatory=$false)]
    [string]$serviceBusNamespace = $username
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

$scriptDirectory = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

$Sequence = $username.split('-')[-1]
$ResourceGroupName =  'lab001-weu-mgmt-twkrs-rsg-{0:000}' -f $Sequence
$sqlServerName = 'twkrs-{0:000}-sql' -f $Sequence

$ServiceBusKey = (Get-AzServiceBusKey -ResourceGroupName $ResourceGroupName -Namespace $serviceBusNamespace -Name RootManageSharedAccessKey).PrimaryKey

$ServiceBusOutputObject = (Get-Content (Join-Path $scriptDirectory 'json/OutputServiceBus.json') | ConvertFrom-Json)
$ServiceBusOutputObject.name = 'BeerPouringLive'
$ServiceBusOutputObject.properties.datasource.properties.serviceBusNamespace = $username
$ServiceBusOutputObject.properties.datasource.properties.SharedAccessPolicyKey = $ServiceBusKey

$ServiceBusTempInputFile = New-TemporaryFile
$ServiceBusOutputObject | ConvertTo-Json -Depth 25 -Compress > $ServiceBusTempInputFile

New-AzureRmStreamAnalyticsOutput -ResourceGroupName $ResourceGroupName -File $ServiceBusTempInputFile -JobName $jobName -Name 'BeerPouringLive' -Force | Out-Null
Remove-Item $ServiceBusTempInputFile

$DataBaseOutputObject = (Get-Content (Join-Path $scriptDirectory 'json/OutputDatabase.json') | ConvertFrom-Json)
$DataBaseOutputObject.name = 'BeerPouringArchive'
$DataBaseOutputObject.properties.datasource.properties.server = ('{0}.database.windows.net' -f $sqlServerName)
$DataBaseOutputObject.properties.datasource.properties.user = $sqluser
$DataBaseOutputObject.properties.datasource.properties.password = $sqlpassword
$DataBaseOutputObject.properties.datasource.properties.table = 'BeerPouringArchive'

$DataBaseTempInputFile = New-TemporaryFile
$DataBaseOutputObject | ConvertTo-Json -Depth 25 -Compress > $DataBaseTempInputFile

New-AzureRmStreamAnalyticsOutput -ResourceGroupName $ResourceGroupName -File $DataBaseTempInputFile -JobName $jobName -Name 'BeerPouringArchive' -Force | Out-Null

Remove-Item $DataBaseTempInputFile
Clear-Variable OutputObject

New-AzStreamAnalyticsTransformation -ResourceGroupName $ResourceGroupName -File (Join-Path $scriptDirectory "json/Transformation.json") -JobName $jobName -Name "Transformation" -Force | Out-Null

Write-Host "Azure StreamAnalyticsJob $JobName updated with the output 'BeerPouringLive'"
