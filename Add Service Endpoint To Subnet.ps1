function Add-ServiceEndpointToSubnet {
    param (
        [string]$ResourceGroupName,
        [string]$VnetName,
        [string]$SubnetName,
        [string]$Service
    )

    # Get the virtual network and subnet
    $vnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VnetName
    $subnet = $vnet | Select-Object -ExpandProperty Subnets | Where-Object { $_.Name -eq $SubnetName }

    if (-not $subnet) {
        Write-Error "Subnet '$SubnetName' not found in virtual network '$VnetName'."
        return
    }

    # Create the PSServiceEndpoint for the specified service
    $serviceEndpoint = New-Object Microsoft.Azure.Commands.Network.Models.PSServiceEndpoint
    $serviceEndpoint.Service = $Service

    # Add the service endpoint to the subnet's ServiceEndpoints collection
    $subnet.ServiceEndpoints.Add($serviceEndpoint)

    # Update the virtual network with the modified subnet
    Set-AzVirtualNetwork -VirtualNetwork $vnet

    Write-Host "Service endpoint for $Service has been added to the subnet '$SubnetName'."
}

# Example usage
Add-ServiceEndpointToSubnet -ResourceGroupName "txbackbonehosta-rg" -VnetName "txbackbonevnethosta401" -SubnetName "tnsqlnhostaa401" -Service "Microsoft.Storage"
