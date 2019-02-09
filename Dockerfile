ARG FROM
FROM ${FROM}

# TODO: Drop this? HTTPS termination should happen at the reverse proxy and this is not used anyway.
# Generate a self-signed cert
RUN set -xe; \
	apk add --no-cache openssl bash && mkdir -p /etc/nginx/ssl; \
	openssl req -batch -x509 -newkey rsa:4096 -days 3650 -nodes -sha256 -subj "/" \
		-keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt; \
	apk del openssl; \
	rm -rf /etc/nginx/conf.d/*

# Copy default docroot to /var/www/docroot
RUN set -xe; \
	mkdir -p /var/www/docroot; \
	cp -R /usr/share/nginx/html/. /var/www/docroot

ARG GOMPLATE_VERSION=3.0.0

# Install gomplate
RUN set -xe; \
	wget -q https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-amd64-slim -O /usr/local/bin/gomplate; \
	chmod +x /usr/local/bin/gomplate

COPY conf /etc/nginx/
COPY docker-entrypoint.d /etc/docker-entrypoint.d/
COPY bin /usr/local/bin/

ENV NGINX_FCGI_HOST_PORT="cli:9000"
ENV NGINX_SERVER_ROOT="/var/www/docroot"
ENV NGINX_VHOST_PRESET="html"

WORKDIR /var/www

EXPOSE 80 443

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["docker-healthcheck.sh"]
