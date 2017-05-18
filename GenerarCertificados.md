# Generar certificados para VPN

1. Generar certificado raíz autofirmado
    - Se guarda en C:/Users/xxx/
    - makecert -sky exchange -r -n "CN=P2SRootCert" -pe -a sha1 -len 2048 -ss My "P2SRootCert.cer"
  
2. Exportar clave pública
   - Abrir mmc
   - Archivo/Agregar o quitar complementos/
   - cerftificados -> agregar (mi cuenta de usuario)
   - Personal/Certificados/Todas las tareas/Exportar
   - No exportar clave privada/Base 64
   
3. Crear certificados de cliente
    - makecert.exe -n "CN=P2SClientCert" -pe -sky exchange -m 96 -ss My -in "P2SRootCert" -is my -a sha1
  
4. Exportar certificado de cliente
    - Abrir mmc
    - Exportar clave privada
    - Incluir... (si es posible)
  
5. Instalar certificado cliente

## Tutorial completo 
[Tutorial](https://docs.microsoft.com/es-es/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal#a-namegeneratecertaparte-6-generación-de-certificados)
