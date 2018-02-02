Add-AzureRmAccount

$SubscriptionName = ( Get-AzureRmSubscription | Out-GridView -Title "Select an Azure Subscription ..." -PassThru).Name
Set-AzureRmContext -SubscriptionName $SubscriptionName

$RGName = (Get-AzureRmResourceGroup | Out-GridView -Title "Select an Azure Resource Group ..." -PassThru).ResourceGroupName
$ip = Get-AzureRmPublicIpAddress -ResourceGroupName $RGName | Out-GridView -Title "Select an Azure Public IP Address ..." -PassThru
$IPName = $ip.Name
Write-Host ("Idle time: {0} minutes" -f $ip.IdleTimeoutInMinutes)

do{
	$change = Read-Host -Prompt "Change IP idle time? (Y/N)"
	if($change -eq "Y" -or $change -eq "N"){
		$ok = $true
	}
} until ($ok)

if ($change -eq "Y"){
	do{
		try {
			$numOk = $true
			[int]$newIdleTime = Read-Host -Prompt "Insert new IP idle time (4-30 minutes)"
		} catch {
			$numOK = $false
		}
	} until ($numOk -and $newIdleTime -ge 4 -and $newIdleTime -le 30)

    $ip = Get-AzureRmPublicIpAddress -Name $IPName -ResourceGroupName $RGName
    $ip.IdleTimeoutInMinutes = $newIdleTime
    Set-AzureRmPublicIpAddress -PublicIpAddress $ip
	
	$ip = Get-AzureRmPublicIpAddress -Name $IPName -ResourceGroupName $RGName
	Write-Host ("Idle time: {0} minutes" -f $ip.IdleTimeoutInMinutes)
} elseif ($change -eq "N"){
	Write-Host ("IP idle time won't be changed")
}