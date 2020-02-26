#! /bin/env pwsh
Param (
    $username,
    $jobName,
    $serviceBusNamespace = $username
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

$ServiceBusKey = Get-AzServiceBusKey -ResourceGroupName $ResourceGroupName -Namespace $serviceBusNamespace -Name RootManageSharedAccessKey

$OutputObject = (Get-Content (Join-Path $scriptDirectory 'OutputServiceBus.json') | ConvertFrom-Json)
$OutputObject.properties.datasource.properties.serviceBusNamespace = $username
$OutputObject.properties.datasource.properties.SharedAccessPolicyKey = $ServiceBusKey

$TempInputFile = New-TemporaryFile
$OutputObject | ConvertTo-Json -Depth 25 -Compress > $TempInputFile

New-AzureRmStreamAnalyticsOutput -ResourceGroupName $ResourceGroupName -File $TempInputFile -JobName $jobName -Name $OutputName -Force
Remove-Item $TempInputFile

New-AzStreamAnalyticsTransformation -ResourceGroupName $ResourceGroupName -File (Join-Path $scriptDirectory "Transformation.json") -JobName $jobName -Name "Transformation"

