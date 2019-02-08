ARG VERSION
FROM nginx:${VERSION}-alpine

ENV NGINX_BACKEND_HOST="cli"
ENV NGINX_BACKEND_PORT="9000"
ENV NGINX_VHOST_PRESET="html"
ENV NGINX_SERVER_ROOT="/var/www/docroot"

USER root

RUN apk add --no-cache openssl bash && mkdir -p /etc/nginx/ssl \
	&& openssl req -batch -x509 -newkey rsa:4096 -days 3650 -nodes -sha256 -subj "/" \
		-keyout /etc/nginx/ssl/server.key -out /etc/nginx/ssl/server.crt \
	&& apk del openssl \
	&& rm -rf /etc/nginx/conf.d/*

COPY conf /etc/nginx/
COPY docker-entrypoint.d /etc/docker-entrypoint.d/
COPY bin /usr/local/bin/

EXPOSE 80 443

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["healthcheck.sh"]
