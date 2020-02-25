#region Parameters

$username = "tweaker99@sbpplayground.onmicrosoft.com"
$password = "ReplaceWithYourPassword"

$tenantId = "2ba489e8-3466-4f52-a32d-263d28b832e1"
$subscriptionId = "b5f5e722-d325-4261-98e1-81d2d707bd86"
$resourceGroupName = "lab001-weu-mgmt-twkrs-rsg-099"

#endregion Parameters

#region Binding

$credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $(ConvertTo-SecureString $password -AsPlainText -Force)
Login-AzAccount -Tenant $tenantId -Credential $credential -Subscription $subscriptionId
Get-AzResourceGroup $resourceGroupName

#endregion Binding

