# Clonar Máquina 

1. Clonar discos
    - Clonar dentro de la misma suscripcion:
      - Es suficiente con crear un nuevo contenedor (cloudberry) y copiar aquí los vhds

    - Clonar a otra suscripcion:
      - crear un nuevo contenedor (cloudberry)
      - copiar aquí los vhds
      - crear una nueva cuenta de almacenamiento en la nueva suscripción
      - copiar los vhd a la nueva cuenta

2. Crear máquina
    - Crear la máquina en la suscripcion destino desde plantilla (implementacion de plantillas) con el disco de sistema anteriormente clonado

3. Configurar Redes/grupos seguridad...

4. Cambiar el hostname
	- En /etc/hostname
	- En /etc/hosts si hubiera algo que cambiar aquí
	- En /var/lib/waagent/ovf-env.xml
Habrá que reiniciar la máquina para que pille los cambios.
	
- En ocasiones no funcionarán las credenciales al crear la VM a partir de un vhd o las desconoceremos para solventarlo:
	- Desde la consola de Azure creamos un nuevo usuario admintemp (en Reestablecer contraseña -> Si el usuario indicado no existe lo crea con permisos de administrador)
	- Nos conectamos a la máquina con este usuario admintemp
	- Cambiamos la contraseña del usuario original (administrador, por ejemplo) con:
		$ sudo passwd {usuario}
	- Cerramos esta sesión e iniciamos con el usuario al que le hemos cambiado la contraseña
	- Borramos el usuario temporal con:
		$ sudo userdel admintemp

5. Montar disco de datos
    - [Linux](../master/AcoplarDisco.md)
    - [Windows](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-attach-disk-portal)
