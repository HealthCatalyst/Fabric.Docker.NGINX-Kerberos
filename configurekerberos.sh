#!/bin/bash
echo "configuring kerberos..."
domain=$1
dc=$2
uppercasedomain=${domain^^}
lowercasedomain=${domain,,}
cat > /etc/krb5.conf << EOF
[libdefaults]
    default_tkt_enctypes = arcfour-hmac-md5
    default_tgs_enctypes = arcfour-hmac-md5
    default_keytab_name  = FILE:/etc/user.keytab
    default_realm        = $uppercasedomain 
    ticket_lifetime      = 24h
    kdc_timesync         = 1
    ccache_type          = 4
    forwardable          = false
    proxiable            = false

[realms]
    FABRIC.LOCAL = {
        kdc            = $dc.$lowercasedomain 
	admin_server   = $dc.$lowercasedomain 
	default_domain = $lowercasedomain 
    }

[domain_realm]
    .kerberos.server = $uppercasedomain 
    .fabric.local    = $uppercasedomain 
EOF
echo "kerberos configured as: "
cat /etc/krb5.conf
