Login-AzureRmAccount

$subscriptionId = 
    ( Get-AzureRmSubscription |
        Out-GridView `
          -Title "Select an Azure Subscription ..." `
          -PassThru
    ).SubscriptionId

Select-AzureRmSubscription `
    -SubscriptionId $subscriptionId

 
# VNET Resource Group and Name
$rgName =
    ( Get-AzureRmResourceGroup |
        Out-GridView `
          -Title "Select an Azure Resource Group ..." `
          -PassThru
    ).ResourceGroupName

$vnetGwName = 
    ( Get-AzureRmVirtualNetworkGateway `
        -ResourceGroupName $rgName
    ).Name |
    Out-GridView `
        -Title "Select an Azure VNET Gateway ..." `
        -PassThru

$timestamp = get-date -uFormat "%d%m%y@%H%M%S"

$captureDuration = 120
$storageContainer = "vpnlogs"
$logDownloadPath = "D:"
$Logfilename = "VPNDiagLog_" + $vnetGwName + "_" + $timestamp + ".txt"
  
$storageAccountName = 
    ( Get-AzureRmStorageAccount `
        -ResourceGroupName $rgName
    ).StorageAccountName |
    Out-GridView `
        -Title "Select an Azure Storage Account ..." `
        -PassThru

#Get Key for Azure Storage Account

$storageAccountKey = 
    ( Get-AzureRmStorageAccountKey `
          -Name $storageAccountName `
          -ResourceGroupName $rgName
    )[0].Value

Add-AzureAccount

Select-AzureSubscription `
    -SubscriptionId $subscriptionId

# Set Storage Context for storing logs

$storageContext = 
    New-AzureStorageContext `
        -StorageAccountName $storageAccountName `
        -StorageAccountKey $storageAccountKey

$vnetGws = Get-AzureVirtualNetworkGateway 

$vnetGwId = 
    ( $vnetGws | 
        ? GatewayName -eq $vnetGwName 
    ).GatewayId
 
# Start Azure VNET Gateway logging
Start-AzureVirtualNetworkGatewayDiagnostics  `
    -GatewayId $vnetGwId `
    -CaptureDurationInSeconds $captureDuration `
    -StorageContext $storageContext `
    -ContainerName $storageContainer
  
# Wait for diagnostics capturing to complete
Sleep -Seconds $captureDuration
 
 
# Step 6 - Download VNET gateway diagnostics log
$logUrl = ( Get-AzureVirtualNetworkGatewayDiagnostics -GatewayId $vnetGwId).DiagnosticsUrl
$logContent = (Invoke-WebRequest -Uri $logUrl).RawContent
$logContent | Out-File -FilePath $logDownloadPath\$Logfilename
