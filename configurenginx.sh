#!/bin/bash
echo "configuring nginx..."
localhost=$1
domain=$2
uppercasedomain=${domain^^}
lowercasedomain=${domain,,}
remoteport=$3
cat > /etc/nginx/conf.d/default.conf << EOF
server {
        server_name $localhost.$lowercasedomain;

	listen 80;
	location / {
		proxy_pass http://localhost:$remoteport;
		proxy_http_version 1.1;
		proxy_set_header Upgrade \$http_upgrade;
		proxy_set_header Connection keep-alive;
		proxy_set_header Host \$host;
		proxy_set_header X-Real-IP \$remote_addr;
		proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header X-Forwarded-Proto \$scheme;
		proxy_set_header X-Forwarded-Host \$server_name;
		proxy_cache_bypass \$http_upgrade;
		auth_gss on;
		auth_gss_keytab /etc/nginx/user.keytab;
		auth_gss_service_name HTTP/$localhost.$lowercasedomain;
		auth_gss_realm $uppercasedomain;
		auth_gss_allow_basic_fallback off;
	}
}
EOF
echo "nginx configured as:"
cat /etc/nginx/conf.d/default.conf
