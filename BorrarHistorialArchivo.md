# Borrar historial de modificación manteniendo únicamente la última versión

### Desde GitShell

1. Modifiar el archivo quitando el contenido sensible
2. Clonar repositorio con la flag --mirror
    - git clone --mirror git://example.com/some-big-repo.git
    
3. Ir a la carpeta local donde se ha clonado 
4. Eliminar fichero conservando la última versión
    - bfg --delete-files <fileName.extension> <git repo name>.git
5. cd <repo name>.git
6. git reflog expire --expire=now --all && git gc --prune=now --aggressive
7. git push
