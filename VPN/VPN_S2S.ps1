Add-AzureRmAccount

Set-AzureRmContext -SubscriptionName "Ecoembes"

$RG1 = "xxx-rg"
$Location = "West Europe"
$sharedKey = "xxx"
$GWName1 = "xxx"

$vnet1gw = Get-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $RG1
$vnet1gw.Name
$vnet1gw.Id

$vnet5gw = New-Object -TypeName Microsoft.Azure.Commands.Network.Models.PSVirtualNetworkGateway
$vnet5gw.Name = "xxx"
$vnet5gw.Id   = "/subscriptions/xxxx/resourceGroups/rg-xxx/providers/Microsoft.Network/virtualNetworkGateways/xxx"
$Connection15 = "VnetSWtoVNetDevSW"
New-AzureRmVirtualNetworkGatewayConnection -Name $Connection15 -ResourceGroupName $RG1 -VirtualNetworkGateway1 $vnet1gw -VirtualNetworkGateway2 $vnet5gw -Location $Location -ConnectionType Vnet2Vnet -SharedKey $sharedKey
