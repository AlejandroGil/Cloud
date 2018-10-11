# Configurar repositorio codecommit

#### Instalar AWS CLI

Instalar Python 3.6 y AWS CLI siguiendo la guía oficial

- Windows: https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-windows.html#awscli-install-windows-pip

- Linux: https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html

Después, instalar algunas librerías de Python usando pip:
```
pip install --user boto3 configparser
```

#### Instalar Git

Para poder trabajar con los repositorios Git se necesita tener configuradas las claves de acceso temporales y hacer que AWS CLI gestione esas credenciales y no el Credential Manager de Windows ni el que instala Git.

Instalar Git (https://git-scm.com/download/win) desmarcando la opción de que instale un gestor de credenciales. Si ya lo tenemos instalado, pasar al siguiente paso.


#### Obtener credenciales 

El comando aws configure genera dos ficheros de configuración en el HOME del usuario: ~/.aws/credentials (Linux) o %UserProfile%.aws\credentials (Windows).
La Access Key ID y Secrete Access key es única por cada usuario (no se deben compartir).

La región por defecto será `eu-west-1` y el formato de salida `json`

```
aws configure
```

#### Configuración de AWS CLI

Crear un perfil AWS con el nombre deseado (normalmente referente al rol que se va a asumir) para la gestión de las credenciales temporales. Para ello, es necesario editar el fichero `credentials` que se generó en el paso anterior para añadir los siguientes campos, sustituyendo los campor por sus valores correspondiente.

```
[<nombre_cuenta>]
account_id = <account_id>
role = <nombre_rol>
mfa_serial = arn:aws:iam::xxxxxx:mfa/<nombre_usuario>
```

#### Obtener credenciales temporales

El siguiente paso es obtener las credenciales temporales y el token de sesión. Este paso se debe repetir cada vez que la sesión caduque (está configurado a 8 horas y devolverá un error 403 en las peticiones una vez hayan pasado esas horas). Para ello se ejecuta el script de Python `assume_role.py`

```
set AWS_PROFILE=
python assume_role_v2.py <nombre_cuenta> <token_mfa> -> Código obtenido de Google Authenticator
set AWS_PROFILE=<nombre_cuenta>
```

#### Configurar Git

Configurar el credential helper para Git que viene con AWS CLI para que use el perfil que hemos añadido en la configuración de AWS CLI.

```
git config --global credential.helper "!aws codecommit credential-helper --profile <nombre_cuenta> $@" 
git config --global credential.UseHttpPath true
```

Los anteriores comandos git config deberían añadir al fichero .gitconfig (C:\Users\xxx\.gitconfig) una sección [credential]. Igual de importante es la sección [http] con el proxy configurado si estamos en la red de Indra.

```
[http]
    proxy = http://proxy.indra.es:8080
```

#### Configuración SourceTree

La integración con Sourcetree para trabajar con Git debería ser transparente si se han seguido los todos los pasos.

La primera vez que se haga una operación en Sourcetree es posible que salte la autenticación de Windows, ventana que debe ser cerrada sin rellenar. Al pulsar cancelar, se almacenarán en el Credential Manager las claves temporales configuradas en `tools/options/Authentication`

Cuando se renueve la sesión hay que borrar las credenciales anteriores para que las relea del fichero credentials donde 

`tools/options/Authentication/aws.codecommit...`
