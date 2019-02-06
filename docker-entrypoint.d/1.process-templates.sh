#!/bin/bash

process_template()
{
    src=${1}
    dst=${2}
    for variable in NGINX_VHOST_PRESET NGINX_BACKEND_HOST NGINX_BACKEND_PORT NGINX_VHOST_PRESET NGINX_SERVER_ROOT
    do
	eval value=\$${variable}
	sed 's#{{ '${variable}' }}#'${value}'#g' ${src} > ${dst}
    done
}

process_template /etc/nginx/nginx.conf.tmpl /etc/nginx/nginx.conf
process_template /etc/nginx/vhost.conf.tmpl /etc/nginx/conf.d/vhost.conf
process_template /etc/nginx/includes/defaults.conf.tmpl /etc/nginx/includes/defaults.conf

