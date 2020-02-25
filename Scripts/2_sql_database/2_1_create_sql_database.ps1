#region Parameters

$username = "tweaker-099@sbpplayground.onmicrosoft.com"
[int]$index = $username.Split('@').split('-')[1]
$password = "P@ssW0rD!{0:000}" -f $index

$tenantId = "2ba489e8-3466-4f52-a32d-263d28b832e1"
$subscriptionId = "b5f5e722-d325-4261-98e1-81d2d707bd86"
$resourceGroupName = "lab001-weu-mgmt-twkrs-rsg-{0:000}" -f $index

$SQLCredentialUsername = $username.Split('@')[0]
#$SQLCredentialPassword = $password
$SQLCredentialPassword = "JustAr@nd0m@55W0rd"

#endregion Parameters

#region Binding

$credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $(ConvertTo-SecureString $password -AsPlainText -Force)
Login-AzAccount -Tenant $tenantId -Credential $credential -Subscription $subscriptionId
$ResourceGroup = Get-AzResourceGroup $resourceGroupName
$ResourceGroup

#endregion Binding

#region Provisioning

    $SQLServerName = "twkrs-{0:000}-sql" -f $index
    $SQLDatabaseName = "tweakers_db"
    $SQLCredential = new-object -typename System.Management.Automation.PSCredential -argumentlist $SQLCredentialUsername, $(ConvertTo-SecureString $SQLCredentialPassword -AsPlainText -Force)
    New-AzSqlServer -ServerName $SQLServerName -ResourceGroupName $resourceGroupName -Location $ResourceGroup.Location -SqlAdministratorCredentials $SQLCredential
    #Get-AzSqlServer -ServerName $SQLServerName -ResourceGroupName $resourceGroupName
    $MyIP = curl ifconfig.me
    New-AzSqlServerFirewallRule -ServerName $SQLServerName -ResourceGroupName $resourceGroupName -FirewallRuleName "KnockKnock" -StartIpAddress $MyIP -EndIpAddress $MyIP
    New-AzSqlDatabase -ServerName $SQLServerName -DatabaseName $SQLDatabaseName -ResourceGroupName $resourceGroupName -Edition Basic

#endregion Provisioning

#region Deprovisioniong

    #Remove-AzSqlServer -ResourceGroupName $resourceGroupName -ServerName $SQLServerName -Force

#endregion Deprovisioniong