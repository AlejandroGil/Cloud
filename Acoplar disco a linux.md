# Acoplar disco a Linux

1. Miramos el ultimo disco
   - sudo grep SCSI /var/log/messages
   - En Ubuntu
     - sudo grep SCSI /var/log/syslog

2. Listar particiones
sudo fdisk -l

3. Creamos la particion
sudo fdisk /dev/sdc
n
(enter)
(enter)
(enter)
(enter)
w

4. Le damos formato
sudo mkfs -t ext4 /dev/sdc1

5. Lo montamos
sudo mkdir /datadrive
sudo mount /dev/sdc1 /datadrive

6. Consultamos el UUID
sudo -i blkid

7. Añadimos el UUID al fstab (UUID=c13dea28-d619-4e55-b574-c5e766bc18e9 /datadrive              ext4    defaults        1 2)
sudo vi /etc/fstab

8. Probamos que se desmonta y monta correctamente
sudo umount /datadrive
sudo mount /datadrive

9. Damos permisos sobre el directorio
sudo chmod go+w /datadrive


### Disco remoto
1. Añadimos una línea al fstab:
   - (//url/almacenamiento /directorio/en/la/vm cifs vers=3.0,username={cuenta},password={pass},dir_mode=0770,file_mode=0770,uid=apache,gid=apache)
   - sudo vi /etc/fstab

\\cervantesprostorage.file.core.windows.net\cervantespro-shared  /shared cifs vers=3.0,username=cervantesprostorage,password=GuBlPJdra6mKl2ii81tUGqxX7mMxMyEvkopJ/Qsq0txIPXLLjMlh18cS3RwnzPYF1RnOLr5p9G9ZnQEtHxNsFg==,dir_mode=0770,file_mode=0770,uid=apache,gid=apache
