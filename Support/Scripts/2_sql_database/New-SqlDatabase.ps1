<#
        .SYNOPSIS
        Helper script to create an Azure SQL DB
        .PARAMETER Username
        Event Azure username assigned (tweaker-###) does not need the @...
        .EXAMPLE
        ./New-SqlDatabase.ps1 -username tweaker-001
        .LINK
        https://github.com/schubergphilis/tweakers_iot_workshop/blob/master/Reporting/2_sql_database.md
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

if ($username.contains('@')) {
    $username = $username.split('@')[0]
}

$location = "West Europe"

$Sequence = $username.split('-')[1]
$SqlPassword = "aR@nd0mP@55W0rd!" -f $Sequence

$ResourceGroupName =  'lab001-weu-mgmt-twkrs-rsg-{0:000}' -f $Sequence
$SQLServerName = "twkrs-{0:000}-sql" -f $Sequence

$SQLCredential = New-Object -typename System.Management.Automation.PSCredential `
    -argumentlist $username, (ConvertTo-SecureString $SqlPassword -AsPlainText -Force)

Write-Host Creating SQL server and Database, this can take a while ...

$SqlServer = New-AzSqlServer -ServerName $SQLServerName -ResourceGroupName $ResourceGroupName -Location $location -SqlAdministratorCredentials $SQLCredential

New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SQLServerName  `
    -FirewallRuleName "SBPVisitor" `
    -StartIpAddress '95.142.96.53' `
    -EndIpAddress '95.142.96.53' | Out-Null

New-AzSqlServerFirewallRule -ResourceGroupName $ResourceGroupName -ServerName $SQLServerName  `
    -FirewallRuleName "SBPOffice" `
    -StartIpAddress '195.66.90.65' `
    -EndIpAddress '195.66.90.65' | Out-Null

New-AzSqlDatabase -ResourceGroupName $ResourceGroupName -ServerName $SQLServerName `
    -DatabaseName 'tweakers_db' `
    -Edition Basic | Out-Null

Write-Host SQL password is: $SqlPassword
Write-Host SQL endpoint is: $SqlServer.FullyQualifiedDomainName
