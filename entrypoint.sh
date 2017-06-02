#!/bin/bash
./opt/install/configurekerberos.sh $domain $dc
./opt/install/configurenginx.sh $localhost $domain $remoteport
./opt/install/setupkeytab.sh $username $domain $password $kvno
mv user.keytab /etc/nginx/user.keytab
chmod 740 /etc/nginx/user.keytab
chown root:nginx /etc/nginx/user.keytab
exec nginx -g "daemon off;"
#exec /bin/bash
