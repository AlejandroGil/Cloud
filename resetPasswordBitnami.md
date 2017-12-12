#### Reset password Bitnami MySQL

1. Create a file in `/home/bitnami/mysql-init` with the content shown below (replace NEW_PASSWORD with the password you wish to use):

    ```sql
    UPDATE mysql.user SET Password=PASSWORD('NEW_PASSWORD') WHERE User='root';
    FLUSH PRIVILEGES;
    ```

If your stack ships MySQL v5.7.x, use the following content instead of that shown above:

    ```sql
    UPDATE mysql.user SET authentication_string=PASSWORD('NEW_PASSWORD') WHERE User='root';
    FLUSH PRIVILEGES;
    ```

    TIP: Check the MySQL version with the command /opt/bitnami/mysql/bin/mysqladmin --version or /opt/bitnami/mysql/bin/mysqld --version.

2. Stop the MySQL server:
  
    ```java
    sudo /opt/bitnami/ctlscript.sh stop mysql
    ```

3. Start MySQL with the following command:

    ```java
    sudo /opt/bitnami/mysql/bin/mysqld_safe --pid-file=/opt/bitnami/mysql/data/mysqld.pid --datadir=/opt/bitnami/mysql/data --init-file=/home/bitnami/mysql-init 2> /dev/null &
    ```

4. Restart the MySQL server:
    
    ```java
    sudo /opt/bitnami/ctlscript.sh restart mysql
    ```

5. Remove the script:

    ```java
    rm /home/bitnami/mysql-init
    ```

