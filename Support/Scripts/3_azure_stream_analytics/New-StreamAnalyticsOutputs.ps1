<#
        .SYNOPSIS
        Helper script to create an Azure SQL DB
        .PARAMETER Username
        Event Azure username assigned (tweaker-###) does not need the @...
        .PARAMETER JobName
        Specifies the name of the Azure Stream Analytics job to update.
        .PARAMETER sqluser
        Specifies the login ID for making a SQL Server Authentication connection to an instance of the Database Engine.
        .PARAMETER sqlpassword
        Specifies the password for the SQL Server Authentication login ID that was specified in the sqluser parameter
        .EXAMPLE
        ./New-StreamAnalyticsOutputs.ps1 -username tweaker-001 -JobName BeerJob -sqluser tweaker-001 -sqlpassword aR@nd0mP@55W0rd!
        .LINK
        https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Reporting/3_azure_stream_analytics.md#configuring-the-stream-analytics-job-outputs
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
    [string]$sqlpassword
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

$StreamAnalyticsJob = Get-AzStreamAnalyticsJob -ResourceGroupName $ResourceGroupName -Name $JobName -ErrorAction SilentlyContinue
if ([String]::IsNullOrEmpty($StreamAnalyticsJob) -eq $true) {
    Write-Error "Create a Azure StreamAnalyticsJob first!"
    exit
}

$Outputs = @('BeerIOStat','BeerRall','BeerTemperature')
foreach ($OutputName in $Outputs) {
    $OutputObject = (Get-Content (Join-Path $scriptDirectory 'json/OutputDatabase.json') | ConvertFrom-Json)
    $OutputObject.name = $OutputName
    $OutputObject.properties.datasource.properties.server = ('{0}.database.windows.net' -f $sqlServerName)
    $OutputObject.properties.datasource.properties.user = $sqluser
    $OutputObject.properties.datasource.properties.password = $sqlpassword
    $OutputObject.properties.datasource.properties.table = $OutputName

    $TempInputFile = New-TemporaryFile
    $OutputObject | ConvertTo-Json -Depth 25 -Compress > $TempInputFile

    New-AzureRmStreamAnalyticsOutput -ResourceGroupName $ResourceGroupName -File $TempInputFile -JobName $jobName -Name $OutputName -Force | Out-Null

    Remove-Item $TempInputFile
    Clear-Variable OutputObject
}

New-AzStreamAnalyticsTransformation -ResourceGroupName $ResourceGroupName -File (Join-Path $scriptDirectory "json/Transformation.json") -JobName $jobName -Name "Transformation" -Force | Out-Null

Write-Host "Azure StreamAnalyticsJob $JobName updated with the following outputs"
Write-Host "Outputs: $($Outputs.split(',') -join ", ")"
