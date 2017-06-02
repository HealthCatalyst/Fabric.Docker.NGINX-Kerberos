FROM nginx

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y -qq && apt-get install -y --no-install-recommends \
	build-essential \
	libkrb5-dev \
	libcurl4-openssl-dev \
	curl \
	libpcre3 \
	libpcre3-dev \
	zlib1g-dev \
	krb5-user \
	git

RUN cd /usr/src && mkdir nginx \
	&& curl -fSL https://nginx.org/download/nginx-1.11.13.tar.gz -o nginx.tar.gz \
	&& tar -xzf nginx.tar.gz -C nginx --strip-components=1

RUN cd /usr/src/nginx \
	&& git clone https://github.com/stnoonan/spnego-http-auth-nginx-module.git

RUN cd /usr/src/nginx \
	&& ./configure --with-compat --add-dynamic-module=spnego-http-auth-nginx-module \
	&& make modules \
	&& cp objs/ngx_http_auth_spnego_module.so /etc/nginx/modules/ 

COPY nginx.conf /etc/nginx/nginx.conf
#ADD https://healthcatalyst.github.io/InstallScripts/setupkeytab.txt /opt/install/setupkeytab.sh
#ADD https://healthcatalyst.github.io/InstallScripts/signintoactivedirectory.txt /opt/install/signintoactivedirectory.sh
COPY setupkeytab.sh /opt/install/setupkeytab.sh
COPY configurenginx.sh /opt/install/configurenginx.sh
COPY configurekerberos.sh /opt/install/configurekerberos.sh
COPY entrypoint.sh /opt/install/entrypoint.sh
#COPY default.conf /etc/nginx/conf.d/default.conf
#COPY krb5.conf /etc/krb5.conf

RUN chmod +x /opt/install/setupkeytab.sh \
    #&& chmod +x /opt/install/signintoactivedirectory.sh \
    && chmod +x /opt/install/configurenginx.sh \
    && chmod +x /opt/install/configurekerberos.sh \
    && chmod +x /opt/install/entrypoint.sh

ENTRYPOINT ["/opt/install/entrypoint.sh"]
