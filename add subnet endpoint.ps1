# Define parameters
$ResourceGroupName = "txbackbonehosta-rg"
$VnetName = "txbackbonevnethosta401"
$SubnetName = "tnsqlnhostaa401"

# Get the virtual network and subnet
$vnet = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Name $VnetName
$subnet = $vnet | Select-Object -ExpandProperty Subnets | Where-Object { $_.Name -eq $SubnetName }

# Create the PSServiceEndpoint for Microsoft.Storage
$serviceEndpoint = New-Object Microsoft.Azure.Commands.Network.Models.PSServiceEndpoint
$serviceEndpoint.Service = "Microsoft.Storage"

# Add the service endpoint to the subnet's ServiceEndpoints collection
$subnet.ServiceEndpoints.Add($serviceEndpoint)

# Update the virtual network with the modified subnet
Set-AzVirtualNetwork -VirtualNetwork $vnet

Write-Host "Service endpoint for Microsoft.Storage has been added to the subnet."
