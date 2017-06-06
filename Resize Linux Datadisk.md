# Aumentar disco de datos (Linux)

1. Comprobamos si tiene IP pública y si es fija.
	**ASM**
	En el portal nuevo vamos a la máquina (clásica). Si su IP es un enlace y al hacer click nos lleva a un recurso 'IP reservada (clásico)' es que está reservada.
	**ARM**
	En el portal nuevo vamos a la máquina para ver si tiene IP pública. Si tiene, vamos a interfaz de red, configuraciones de IP y le damos a la que tenga. En esa pantalla podremos ver si la IP pública está reservada.
		
2. Reservamos si la IP que tiene la instancia actual es fija.
	**ASM**
	En Powershell:
	###### Nos conectamos a la suscripción:
		Select-AzureSubscription -SubscriptionName <'nombre suscripción'>
	###### Si la IP no estaba reservada la reservamos:
		New-AzureReservedIP –ReservedIPName <nombreip> –Location "West Europe" -ServiceName 
	**ARM**
	En la pantalla donde hemos visto si está reservada la podemos fijar.
		
3. Aumentar el disco de datos.
	**ASM**
	En Powershell:
	###### Nos conectamos a la suscripción:
		Select-AzureSubscription -SubscriptionName <'nombre suscripción'>
	###### Seleccionamos la cuenta de almacenamiento:
		Set-AzureSubscription -SubscriptionName <'nombre suscripción'> -CurrentStorageAccountName <'nombre cuenta de almacenamiento'>
	###### Seleccionamos la VM:
		$vm = Get-AzureVM
	###### Seleccionamos el disco de datos a redimensionar:
		$disk = $vm | Get-AzureDataDisk 
		$diskName = $disk.DiskName
	###### Especificamos el tamaño en GB del disco de datos (mayor que el anterior):
		$size = do {$size = Read-Host -Prompt "New size in GB"} until ( $size -gt $disk.LogicalDiskSizeInGB )
	###### Paramos y desasignamos la VM
		$vm | Stop-AzureVM -Force
	###### Redimensionamos el disco
		Update-AzureDisk -Label "$diskName" -DiskName "$diskName" -ResizedSizeInGB $size
	###### Iniciamos la VM
		$vm | Start-AzureVM
	**ARM**
	En el portal nuevo:
	· Paramos y desasignamos la VM.
	· Esperamos a que termine.
	· Vamos a sus discos, elegimos el que queremos aumentar, especificamos su nuevo tamaño y guardamos.
	· Esperamos a que termine.
	· Encendemos la VM.
	
4. Aumentar la partición.
	##### Ejecutamos fdisk para consultar y editar las particiones actuales de sdc* (Normalmente el disco de datos se monta aquí)
		sudo fdisk /dev/sdc
	##### Consultamos el tamaño actual de estas particiones
		p
	##### Eliminamos la partición que queramos aumentar
		d
		<número de la partición a borrar>
	##### Comprobamos que se ha borrado
		p
	##### Creamos una nueva ocupando el espacio libre (Los enter son para tomar los valores por defecto)
		n
		(enter)
		(enter)
		(enter)
		(enter)
	##### Comprobamos que se ha ampliado correctamente
		p
	##### Guardamos los cambios
		w
	##### Reiniciamos la máquina
		sudo reboot
		
5. Extender el sistema de archivos.
	**ext4**
	##### Consultamos lo que hay ahora
		df -h
	##### Extendemos el sistema de archivos (sdc1 o la partición que queramos ampliar)
		sudo resize2fs /dev/sdc1
	##### Comprobamos que el cambio se ha realizado correctamente
		df -h
	**ext3** (No probado)
		parted /dev/sdx
		print
		resize N
