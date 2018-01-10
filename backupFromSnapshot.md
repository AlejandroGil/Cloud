#Hacer backup de discos desde una snapshot

1. Desde Azure Storage explorer hacer snapshot
2. En el momenteo de restaurar, apagar la máquina para desbloquearla (###IMPORTANTE)
3. Romper bloqueo (break lease) de la imagen base
4. Hace un "promote" sobre la snapshot

Si no se ha apagado la máquina antes de hacer el bloqueo, habrá que restaurar una VM desde la snapshot
