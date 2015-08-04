#!/bin/bash

if [ -z $1 ]; then

#non è stato specificato il dominio. 

#Usage: ./script.sh dominio.com

echo "No site parameters."

else

#creo le cartelle per il dominio
mkdir /var/www/$1 && mkdir /var/www/$1/public_html

#creo una pagina di prova con phpinfo
echo "<?php phpinfo(); ?>" > /var/www/$1/public_html/index.php

#creo il file di virtual host
(

cat <<EOF

<VirtualHost *:80>

ServerAdmin alexmanno96@gmail.com

ServerName $1

ServerAlias www.$1

DocumentRoot /var/www/$1/public_html

</VirtualHost>

EOF

) > /etc/apache2/sites-available/$1.conf

#attivo il vhost
a2ensite $1.conf && service apache2 reload

echo "Your domain as been configured"

fi