#!/bin/bash

set -e # Fail on errors

# Ensure default includes exist
touch /etc/nginx/includes/upstream.conf

# Generate configs from templates
gomplate --file /etc/nginx/nginx.conf.tmpl --out /etc/nginx/nginx.conf
gomplate --file /etc/nginx/conf.d/vhost.conf.tmpl --out /etc/nginx/conf.d/vhost.conf
gomplate --file /etc/nginx/includes/defaults.conf.tmpl --out /etc/nginx/includes/defaults.conf

if [[ -n "${NGINX_VHOST_PRESET}" ]]; then
	gomplate --file  /etc/nginx/presets/${NGINX_VHOST_PRESET}.conf.tmpl --out /etc/nginx/includes/preset.conf

	if [[ "${NGINX_VHOST_PRESET}" =~ ^drupal|wordpress|php$ ]]; then
		gomplate --file /etc/nginx/includes/upstream.php-fpm.conf.tmpl --out /etc/nginx/includes/upstream.conf
	fi
fi
