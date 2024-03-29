# Note: this is a BuildKit-dependent Dockerfile.
# https://docs.docker.com/engine/reference/builder/#buildkit
ARG UPSTREAM_IMAGE
FROM ${UPSTREAM_IMAGE}

ARG TARGETARCH

# TODO: Drop this? HTTPS termination should happen at the reverse proxy and this is not used anyway.
# Generate a self-signed cert
RUN set -xe; \
	apk add --update --no-cache \
		bash \
		openssl \
	; \
	mkdir -p /etc/nginx/ssl; \
	openssl req -batch -x509 -newkey rsa:4096 -days 3650 -nodes -sha256 -subj "/" \
		-keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt; \
	apk del openssl; \
	rm -rf /var/cache/apk/*; \
	rm -rf /etc/nginx/conf.d/*

# Copy default docroot to /var/www/docroot
RUN set -xe; \
	mkdir -p /var/www/docroot; \
	cp -R /usr/share/nginx/html/. /var/www/docroot

ARG GOMPLATE_VERSION=3.10.0

# Install gomplate
RUN set -xe; \
	apk add --no-cache -t .fetch-deps \
		curl \
	; \
	curl -sSL https://github.com/hairyhenderson/gomplate/releases/download/v${GOMPLATE_VERSION}/gomplate_linux-${TARGETARCH} -o /usr/local/bin/gomplate; \
	chmod +x /usr/local/bin/gomplate; \
	\
	apk del --purge .fetch-deps; \
	rm -rf /var/cache/apk/*

COPY conf /etc/nginx/
COPY docker-entrypoint.d /etc/docker-entrypoint.d/
COPY bin /usr/local/bin/

ENV NGINX_FCGI_HOST_PORT="php-fpm:9000"
ENV NGINX_SERVER_ROOT="/var/www/docroot"
ENV NGINX_VHOST_PRESET="html"

WORKDIR /var/www

EXPOSE 80 443

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["docker-healthcheck.sh"]
