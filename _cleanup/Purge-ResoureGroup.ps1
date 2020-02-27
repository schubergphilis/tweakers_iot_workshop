#! /bin/env pwsh
Param (
    $username
)

function New-AzureLogin()
{
    $context = Get-AzContext

    if (!$context)
    {
        Connect-AzAccount
    }
}

New-AzureLogin

if ($username.contains('@')) {
    $username = $username.split('@')[0]
}

$sequence = $username.split('-')[-1]
$resourceGroupName = "lab001-weu-mgmt-twkrs-rsg-{0:000}" -f $sequence

New-AzResourceGroupDeployment -ResourceGroupName $resourceGroupName -Mode Complete -TemplateFile .\ResourceGroupCleanup.template.json -Force
