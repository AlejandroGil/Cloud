# Particiones menores que 2TB
# Linux

1. Miramos el ultimo disco
   - sudo grep SCSI /var/log/messages
   - En Ubuntu
     - sudo grep SCSI /var/log/syslog
     
### [Script para montar HDD (en sdc)](../master/MontarDisco.sh) ->  wget -O mount.sh https://raw.githubusercontent.com/AlejandroGil/Cloud/master/MontarDisco.sh


2. Listar particiones
   - sudo fdisk -l

3. Creamos la particion
   - sudo fdisk /dev/sdc
   - n
   - (enter)
   - (enter)
   - (enter)
   - (enter)   
   - w

4. Le damos formato
   - sudo mkfs -t ext4 /dev/sdc1

5. Lo montamos
   - sudo mkdir /datadrive
   - sudo mount /dev/sdc1 /datadrive

6. Consultamos el UUID
   - sudo -i blkid

7. Añadimos el UUID al fstab (UUID=c13dea28-d619-4e55-b574-c5e766bc18e9 /datadrive              ext4    defaults        1 2)
   - sudo vi /etc/fstab

8. Probamos que se desmonta y monta correctamente
   - sudo umount /datadrive
   - sudo mount /datadrive

9. Damos permisos sobre el directorio
   - sudo chmod go+w /datadrive


### Disco remoto
1. Añadimos una línea al fstab (credenciales en portal):
   -  //gstplandstorage.file.core.windows.net/shared /shared cifs vers=3.0,username=,password=,dir_mode=0755,file_mode=0755

      
# Windows
 - [Link](https://docs.microsoft.com/en-us/azure/virtual-machines/virtual-machines-windows-attach-disk-portal)
 - Initialize
 - New volume
 
### Disco remoto

1. Guardar credenciales de la cuenta de almacenamiento
   - cmdkey /add:"storage-account-name".file.core.windows.net /user:"storage-account-name" /pass:"storage-account-key"
2. Asignar a unidad la cuenta de almacenamiento (compartido) 
   - net use Y: \\"storage-account-name".file.core.windows.net\"file-storage-name"
   
### Si hay que montar un disco mayor a 2TB:

```
sudo apt-get install lvm2
```

```
sudo vgcreate vg1 /dev/sdc
```
```
sudo lvcreate -l 100%FREE -n lv1 vg1
```
```
sudo mount /dev/mapper/vg1-lv1 /datadrive/
```
```
/dev/mapper/vg1-lv1 /datadrive ext4 defaults 0 0
```

```
cat /etc/mtab
```
