# Clonar Máquina 

1. Clonar discos
  - Clonar dentro de la misma suscripcion:
      *Es suficiente con crear un nuevo contenedor (cloudberry) y copiar aquí los vhds

  - Clonar a otra suscripcion:
      *crear un nuevo contenedor (cloudberry)
      *copiar aquí los vhds
      *crear una nueva cuenta de almacenamiento en la nueva suscripción
      *copiar los vhd a la nueva cuenta

2. Crear máquina
  -Crear la máquina en la suscripcion destino desde plantilla (implementacion de plantillas) con el disco de sistema anteriormente clonado

3. Configurar Redes/grupos seguridad...
4. Montar disco de datos
  - Linux: Acoplar disco a linux.txt
  - Windows: https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-attach-disk-portal
