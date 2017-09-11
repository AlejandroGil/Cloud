$azureAccountName = "account"
$azurePassword = ConvertTo-SecureString "pass" -AsPlainText -Force
$psCred = New-Object System.Management.Automation.PSCredential($azureAccountName, $azurePassword)
#Login-AzureRmAccount -C -Credential $psCred

Add-AzureRmAccount -Credential $psCred

$SubscriptionID = "ID"
Select-AzureRmSubscription -SubscriptionId $subscriptionId

$nsg = Get-AzureRmNetworkSecurityGroup -Name name-nsg -ResourceGroupName name-rg

#Remove all rules Facebook*
#For ($i=0; $i -lt $nsg.SecurityRules.Count; $i++) {
#    $ruleName = $nsg.SecurityRules[$i].Name
#    if ($ruleName -like "Facebook*"){
#        $nsg | Remove-AzureRmNetworkSecurityRuleConfig -Name $ruleName
#        $i--
#    }
#}

#Retrieve IPs
$IPList = ""
$priority=200
For ($i=0; $i -lt $IPList.Count; $i++, $priority++) {
    $ruleName = $("name_xxx" + $i+1)
    $nsg | Add-AzureRmNetworkSecurityRuleConfig -Name $ruleName -Direction Outbound -Priority $priority -Access Allow -SourceAddressPrefix '*'  -SourcePortRange '*' -DestinationAddressPrefix $IPList[$i] -DestinationPortRange 80 -Protocol '*' | Set-AzureRmNetworkSecurityGroup
}

#Set changes to the subscription
$nsg | Set-AzureRmNetworkSecurityGroup
