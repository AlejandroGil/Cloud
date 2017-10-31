# Autenticar contra API Manager usando Azure Active Directory

1. Una vez creados el AD el API manager, se crea el servidor OAuth en la API/security
    - La redirect_uri no importa (http://localhost p.ej) comprobar en ARM que la APP tenga como URL de respuesta esta uri
    
2. Tener en cuenta los parammetros:

    - AD id (tenant) -> en ARM/Active Directory/Propiedades/Id. directorio
    - client_id (id de APP) -> Registrar APP(AD)/id
    - client secret -> API/Security/OAuth
    
3. Petición GET para obtener el código de autorización:

    - https://login.windows.net/{tenant}/oauth2/authorize?client_id={client_id}&response_type=code&redirect_uri={uri}&response_mode=query

4. En la URL devuelve el codigo de autorización {code}
5. Con este codigo formamos la petición POST para conseguir el token de acceso:
    - https://login.windows.net/{tenant}/oauth2/token
    - cuerpo (postman):

|     key       |     value          |
| ------------- |:-------------:     |
| grant_type    | authorization_code |
| client_id     | {client_id}        |
| redirect_uri  | http://localhost   |
| code          | {code}             |
| client_secret | {client_secret}    |

6. Devuelve un json con algunos valores interesantes:
    - access_token: para acceder a los recursos de la api
    - refresh_token: para regenerar el access_token cuandon expira (expires_in)
7. Con el access token es ya posible acceder a los recursos de la API, es necesario:
    - subscription key -> Portal editores/users/Primary key (Si no tiene, se  crea una subscription)
    - request URL -> Portal desarrolladores/APIs/xxx/resource xxx/Request URL
   
8. Con este codigo formamos la petición GET para solicitar recursos:
    - request URL (with params) + headers
    - headers (postman):
    
|     key                     |     value             |
| -------------               |:-------------:        |
| Authorization               | Bearer {access_token} |
| Ocp-Apim-Subscription-Key   | subscription key      |

[Tutorial](https://ahmet.im/blog/azure-rest-api-with-oauth2/)

## Clonar API (git)

git clone https://username:url encoded password@bugbashdev4.scm.azure-api.net/

git clone https://apim:5926b783a487150085030004&201710220723&IbqEktx3r54EL3AW3XHPCuDPznl/eQi/W1QuNicKNztFtzRGfb1yrurZuVlyG5uFusqkt1m5pKM9gl12CDVFsw==@scm.avmservices.es/
