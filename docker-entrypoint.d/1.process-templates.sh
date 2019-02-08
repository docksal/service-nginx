#!/bin/bash

process_template()
{
    src=${1}
    dst=${2}
    cp -f ${src} ${dst}

    for variable in NGINX_VHOST_PRESET NGINX_BACKEND_HOST NGINX_BACKEND_PORT NGINX_VHOST_PRESET NGINX_SERVER_ROOT
    do
	eval value=\$${variable}
	sed -i 's#{{ '${variable}' }}#'${value}'#g' ${dst}
    done
}

:>/etc/nginx/includes/upstream.conf
:>/etc/nginx/includes/preset.conf
:>/etc/nginx/includes/defaults.conf

process_template "/etc/nginx/nginx.conf.tmpl" "/etc/nginx/nginx.conf"
process_template "/etc/nginx/vhost.conf.tmpl" "/etc/nginx/conf.d/vhost.conf"
process_template "/etc/nginx/includes/defaults.conf.tmpl" "/etc/nginx/includes/defaults.conf"

if [[ -n "${NGINX_VHOST_PRESET}" ]]
then
    process_template "/etc/nginx/presets/${NGINX_VHOST_PRESET}.conf.tmpl" "/etc/nginx/includes/preset.conf"
    if [[ "${NGINX_VHOST_PRESET}" =~ ^drupal|wordpress|php$ ]]
    then
        process_template "/etc/nginx/includes/upstream.php.conf.tmpl" "/etc/nginx/includes/upstream.conf"
    fi
fi

