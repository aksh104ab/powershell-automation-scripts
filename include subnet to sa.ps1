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
        [string] $VNetName,git
        [parameter(Mandatory)]
        [string] $SubnetName
    )
	
    Update-AzStorageAccountNetworkRuleSet -ResourceGroupName $StorageResourceGroup -Name $StorageAccountName -DefaultAction Deny | Out-Null   
    $subnet = Get-AzVirtualNetwork -ResourceGroupName $VNetResourceGroup -Name $VNetName | Get-AzVirtualNetworkSubnetConfig -Name $SubnetName

    $networkRule = Get-AzStorageAccountNetworkRuleSet -ResourceGroupName $storageResourceGroup -Name $storageAccountName | select -ExpandProperty VirtualNetworkRules | where VirtualNetworkResourceId -eq $subnet.Id
    if (-not $networkRule) {
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
