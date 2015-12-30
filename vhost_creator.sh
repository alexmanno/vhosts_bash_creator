#!/bin/bash

if [ -z $1 ]; then
	echo "No Site defined"
	exit 1
fi

if [ -z $2 ]; then
	echo "No User defined"
	exit 1
fi

htpasswd -d /etc/vsftpd/ftpd.passwd $2

#creo le cartelle per il dominio
mkdir /var/www/$2
mkdir /var/www/$2/$1 && mkdir /var/www/$2/$1/public_html

chown -R vsftpd:nogroup /var/www/$2

#creo una pagina di prova con phpinfo
echo "<?php phpinfo(); ?>" > /var/www/$2/$1/public_html/index.php

#creo il file di virtual host
(

cat <<EOF

<VirtualHost *:80>

ServerName $1

ServerAlias www.$1

DocumentRoot /var/www/$2/$1/public_html

</VirtualHost>

EOF

) > /etc/apache2/sites-available/$1.conf

#attivo il vhost
a2ensite $1.conf && service apache2 reload
service vsftpd restart
echo "Your domain as been configured"
