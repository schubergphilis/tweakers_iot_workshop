#! /bin/env pwsh
Param (
    $username,
    $jobName,
    $sqluser,
    $sqlpassword
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
$ResourceGroupName =  'lab001-weu-mgmt-twkrs-rsg-{0:000}' -f $Sequence
$sqlServerName = 'twkrs-{0:000}-sql' -f $Sequence

$Outputs = @('BeerIOStat','BeerRall','BeerTemperature')
foreach ($OutputName in $Outputs) {
    $OutputObject = (Get-Content './OutputDatabase.json' | ConvertFrom-Json)
    $OutputObject.name = $OutputName
    $OutputObject.properties.datasource.properties.server = ('{0}.database.windows.net' -f $sqlServerName)
    $OutputObject.properties.datasource.properties.user = $sqluser
    $OutputObject.properties.datasource.properties.password = $sqlpassword
    $OutputObject.properties.datasource.properties.table = $OutputName

    $TempInputFile = New-TemporaryFile
    $OutputObject | ConvertTo-Json -Depth 25 -Compress > $TempInputFile

    New-AzureRmStreamAnalyticsOutput -ResourceGroupName $ResourceGroupName -File $TempInputFile -JobName $jobName -Name $OutputName -Force

    Remove-Item $TempInputFile
    Clear-Variable OutputObject
}

New-AzStreamAnalyticsTransformation -ResourceGroupName $ResourceGroupName -File "./Transformation.json" -JobName $jobName -Name "Transformation"
