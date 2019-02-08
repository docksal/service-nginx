ARG VERSION
FROM wodby/nginx:${VERSION}

ENV NGINX_BACKEND_HOST="cli"
ENV NGINX_BACKEND_PORT="9000"
ENV NGINX_VHOST_PRESET="html"
ENV NGINX_SERVER_ROOT="/var/www/docroot"

USER root

COPY docker-entrypoint-init.d /docker-entrypoint-init.d/
COPY healthcheck.sh /usr/bin/

EXPOSE 80

# Health check script
HEALTHCHECK --interval=5s --timeout=1s --retries=12 CMD ["healthcheck.sh"]
