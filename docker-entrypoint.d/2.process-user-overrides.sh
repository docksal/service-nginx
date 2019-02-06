#!/bin/bash
set -e

# Support for configuration overrides
include_conf ()
{
    src=${1}
    dst=${2}
    if [[ -f "${src}" ]]
    then
	echo "Including configuration overrides from ${src}"
	cp "${src}" "${dst}"
    fi
}

include_conf "/var/www/.docksal/etc/nginx/vhost-overrides.conf" "/etc/nginx/includes/defaults.conf"
include_conf "/var/www/.docksal/etc/nginx/vhosts.conf" "/etc/nginx/conf.d/user-vhost.conf"

