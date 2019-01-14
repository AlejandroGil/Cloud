Add-AzureRmAccount

$locName="northeurope*"
Get-AzureRMVMImagePublisher -Location $locName | Select PublisherName | Where PublisherName -like *sql*

$pubName="MicrosoftSQLServer"
Get-AzureRMVMImageOffer -Location $locName -Publisher $pubName | Select Offer

$offerName="SQL2008R2SP3-WS2008R2SP1"
Get-AzureRMVMImageSku -Location $locName -Publisher $pubName -Offer $offerName | Select Skus

$skuName="Standard"
Get-AzureRMVMImage -Location $locName -Publisher $pubName -Offer $offerName -Sku $skuName | Select Version