# Define the parameters
$ResourceGroupName = "txbackbonehosta-rg"
$StorageAccountName = "tsfssafar401"
$VnetName = "txbackbonevnethosta401"
$SubnetName = "tnsqlnhostaa401"


$storageAccount = Get-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName
$vnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VnetName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name $SubnetName -VirtualNetwork $vnet

# Create a new PSVirtualNetworkRule object
$subnetResourceId = $subnet.Id

# Create the PSVirtualNetworkRule object
$virtualNetworkRule = New-Object -TypeName Microsoft.Azure.Commands.Management.Storage.Models.PSVirtualNetworkRule
$virtualNetworkRule.VirtualNetworkResourceId = $subnetResourceId

# Create the PSNetworkRuleSet object and add the Virtual Network rule
$networkRuleSet = New-Object -TypeName Microsoft.Azure.Commands.Management.Storage.Models.PSNetworkRuleSet
$networkRuleSet.VirtualNetworkRules = @($virtualNetworkRule)

# Add the network rule set to the storage account
$storageAccount.NetworkRuleSet = $networkRuleSet

# Update the Storage Account with the new network rule set
Set-AzStorageAccount -ResourceGroupName $ResourceGroupName -Name $StorageAccountName -NetworkRuleSet $networkRuleSet

