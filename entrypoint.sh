#!/bin/bash
./opt/install/configurekerberos.sh $domain $dc
./opt/install/configurenginx.sh $localhost $domain $remoteport
./opt/install/setupkeytab.sh $username $domain $password
mv user.keytab /etc/user.keytab
exec nginx -g "daemon off;"
#exec /bin/bash
