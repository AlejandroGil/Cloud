# Generar certificados para VPN

1. Generar certificado raíz autofirmado
    - Se guarda en la ruta que se ejecute el comando
    - makecert -sky exchange -r -n "CN=P2SRootCert" -pe -a sha1 -len 2048 -ss My "P2SRootCert.cer"
  
2. Exportar clave pública
   - Ejecutar mmc
   - Archivo/Agregar o quitar complementos/
   - cerftificados -> agregar (mi cuenta de usuario)
   - Personal/Certificados/Todas las tareas/Exportar
   - No exportar clave privada/Base 64
   - Se guarda en C:/Users/xxx
   
3. Crear certificados de cliente
    - makecert.exe -n "CN=P2SClientCert" -pe -sky exchange -m 96 -ss My -in "P2SRootCert" -is my -a sha1
  
4. Exportar certificado de cliente
    - Ejecutar mmc
    - Exportar clave privada
    - Incluir... (si es posible)
  
5. Instalar certificado cliente

#Guardar certificado root en un KeyValut

```powershell
#Login Azure
Add-AzureRmAccount
Set-AzureRmContext -SubscriptionName "name"

#Connect to KV
$vaultName = 'vaultname'
$certificateName = 'rootcert'

#Import certificate to KV
$securepfxpwd = ConvertTo-SecureString –String '******' –AsPlainText –Force
$cer = Import-AzureKeyVaultCertificate -VaultName $vaultName -Name $certificateName -FilePath 'c:\rootcert.pfx' -Password $securepfxpwd

#Export certificate
$secretName = "TestCert"
$kvSecret = Get-AzureKeyVaultSecret -VaultName $vaultName -Name $certificateName
$kvSecretBytes = [System.Convert]::FromBase64String($kvSecret.SecretValueText)
$certCollection = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2Collection
$certCollection.Import($kvSecretBytes,$null,[System.Security.Cryptography.X509Certificates.X509KeyStorageFlags]::Exportable)
 
#Get the file created to local
$password = '*****'
$protectedCertificateBytes = $certCollection.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Pkcs12, $password)
$pfxPath = [Environment]::GetFolderPath("Desktop") + "\testCert.pfx"
[System.IO.File]::WriteAllBytes($pfxPath, $protectedCertificateBytes)

```

## Tutorial completo 
[Tutorial](https://docs.microsoft.com/es-es/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal#a-namegeneratecertaparte-6-generación-de-certificados)
