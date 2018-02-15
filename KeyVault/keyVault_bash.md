# Interaccion con Azure keyVault a través de Azure bash

Acceder a Cloud Shell a traves del portal o desde [https://shell.azure.com](https://shell.azure.com/)

- Listar suscripciones
  ```java
  az account list --all --output table
  ```
  
- Seleccionar suscripcion
  ```java
  az account set --subscription Formación\ Interna
  ```  

- Listar recursos
  ```java
  az resource list --output table
  ```
  
- Listar secrets

  ```java
  az keyvault secret list --vault-name fin-keyvault -o tsv | awk '{ print $2}'
  ```
 
- Obtener usuario (key del secret)
  ```java
  az keyvault secret show --vault-name fin-keyvault --name haramain-username | grep value
  ```
  
- Obtener password (value del secret)
  ```java
  az keyvault secret show --vault-name fin-keyvault --name haramain-password | grep value
  ```

- Crear secret
  ```java
  az keyvault secret set --vault-name fin-keyvault --name test-username --value user123
  ```
  
- Borrar secret
  ```java
  az keyvault secret delete --vault-name fin-keyvault --name test-username
  ```
