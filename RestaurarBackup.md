# Restaurar backup

### VM Clásica

Reservar la IP que tiene la instancia actual.
	#En el portal nuevo (ARM):
		Vamos a la máquina (clásica). Si su IP es un enlace y al hacer click nos lleva a un recurso 'IP reservada (clásico)' es que está reservada.
		Anotamos el nombre de esta IP.
	#En el portal clásico (ASM) o en el portal nuevo (ARM):
		Obtenemos el nombre de la máquina, la cuenta de almacenamiento, el nombre del servicio en la nube, la red virtual y la subred donde está.
	#En Powershell:
		Nos conectamos a la suscripción:
		$ Select-AzureSubscription -SubscriptionName <'nombre suscripción'>
		Si la IP no estaba reservada la reservamos:
		$ New-AzureReservedIP –ReservedIPName <nombreip> –Location "West Europe" -ServiceName 
		
Borrar la instancia actual conservando discos, así podemos arrepentirnos de haberla borrado. Tenemos que borrarla porque no podemos crear una VM con el mismo nombre si ya existe. Dos opciones:
	#En el portal clásico (ASM):
		MÁQUINAS VIRTUALES/<máquina a borrar>/ELIMINAR/Mantener los discos conectados
	#En el portal NUEVO (ARM):
		Máquinas virtuales (clásico)/<máquina a borrar>/Eliminar/<escribimos el nombre de la máquina, NO SELECCIONAMOS LOS DISCOS>/Eliminar
	
Restaurar el backup que nos interese en el mismo servicio Cloud y con el mismo nombre de máquina:
	#En el portal clásico (ASM):
		Servicios de recuperación/ELEMENTOS PROTEGIDOS/<Seleccionamos la máquina a restaurar>/RESTAURAR/<Elegimos el punto de restauración>/<Siguiente>/<Introducimos los datos que anotamos antes>/<Aceptar>
		Podemos consultar el progreso de esta tarea en TRABAJOS.
		
Asignar la IP que hemos reservado previamente al nuevo despliegue.
	#En Powershell:
		Si no lo sabemos, podemos obtener el nombre de la ip:
		$ Get-AzureReservedIP
		Y la asociamos al servicio en la nube:
		$ Set-AzureReservedIPAssociation -ReservedIPName <nombreip> -ServiceName <nombreservicio>
		
Cambiar los extremos configurados (puertos abiertos) para que coincidan el privado y el público (cuando restauras te cambia los públicos).
	#En el portal clásico (ASM):
		Máquinas virtuales/<Elegimos la máquina restaurada>/EXTREMOS/<Seleccionamos cada puerto a cambiar, editar y hacemos coincidir público con privado>/Aceptar
		Entre puerto y puerto habrá que esperar, porque tarda un poco en cambiarse.
