#script to include vnet and subnet on sa
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

##########-------------------------------------------------------------------

function Set-StorageAccountSubnetAccess {
    [CmdletBinding()]
    param(
		[parameter(Mandatory)]
		[string] $StorageResourceGroup,
		[parameter(Mandatory)]
		[string] $StorageAccountName,
		[parameter(Mandatory)]
		[string] $VNetResourceGroup,
		[parameter(Mandatory)]
		[string] $VNetName,
		[parameter(Mandatory)]
		[string] $SubnetName
	)
	
    Update-AzStorageAccountNetworkRuleSet -ResourceGroupName $StorageResourceGroup -Name $StorageAccountName -DefaultAction Deny | Out-Null   
    $subnet = Get-AzVirtualNetwork -ResourceGroupName $VNetResourceGroup -Name $VNetName | Get-AzVirtualNetworkSubnetConfig -Name $SubnetName

	$networkRule = Get-AzStorageAccountNetworkRuleSet -ResourceGroupName $storageResourceGroup -Name $storageAccountName | select -ExpandProperty VirtualNetworkRules | where VirtualNetworkResourceId -eq $subnet.Id
    if(-not $networkRule)
    {
		Add-AzStorageAccountNetworkRule -ResourceGroupName $StorageResourceGroup -Name $StorageAccountName -VirtualNetworkResourceId $subnet.Id | Out-Null
	}
}

$StorageResourceGroup = "txbackbonehosta-rg"
$StorageAccountName = "tsfssafar401"
$VNetResourceGroup = "txbackbonehosta-rg"
$VNetName = "txbackbonevnethosta401"
$SubnetName = "tnsqlnhostaa401"

# Call the function with the defined parameters
Set-StorageAccountSubnetAccess -StorageResourceGroup $StorageResourceGroup `
                                 -StorageAccountName $StorageAccountName `
                                 -VNetResourceGroup $VNetResourceGroup `
                                 -VNetName $VNetName `
                                 -SubnetName $SubnetName
