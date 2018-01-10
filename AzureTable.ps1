#set variables
$subscriptionName = "name"
$resourceGroup = "rg"
$storageAccount = "storage"
$tableName = "table"
$partitionKey = "pkey"
$saContext = (Get-AzureRmStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount).Context
$table = Get-AzureStorageTableTable -resourceGroup $resourceGroup -tableName $tableName -storageAccountName $storageAccount

#insert into table
Add-StorageTableRow -table $table -partitionKey $partitionKey -rowKey ([guid]::NewGuid().tostring()) -property @{"computerName"="COMP01";"osVersion"="Windows 10";"status"="OK"}
