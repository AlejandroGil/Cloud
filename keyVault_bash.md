# Interaccion con Azure keyVault a través de Azure bash

Acceder a Cloud Shel a traves del portal o desde [https://shell.azure.com](https://shell.azure.com/)

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
 
- Obtener usuario (key del secret)
  ```java
  az keyvault secret show --vault-name fin-keyvault --name haramain-username | grep value
  ```
  
 - Obtener password (value del secret)
  ```java
  az keyvault secret show --vault-name fin-keyvault --name haramain-password | grep value
  ```
