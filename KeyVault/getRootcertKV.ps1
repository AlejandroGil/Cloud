Add-AzureRmAccount
Set-AzureRmContext -SubscriptionName "xxxx"
$certificateName = 'xxxx'
$vaultName = 'xxxx'

$secretName = "xxxx"
$password = "xxxx"
$kvSecret = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $certificateName
$kvSecretBytes = [System.Convert]::FromBase64String($kvSecret.SecretValueText)
$certCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$certCollection.Import($kvSecretBytes,$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
$protectedCertificateBytes = $certCollection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $password)
$pfxPath = [Environment]::GetFolderPath("Desktop") + "\MyCert.pfx"
[System.IO.File]::WriteAllBytes($pfxPath, $protectedCertificateBytes)
