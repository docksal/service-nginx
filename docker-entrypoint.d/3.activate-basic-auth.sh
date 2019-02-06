#!/bin/bash
set -e

# Basic HTTP Authentication
if [[ "${APACHE_BASIC_AUTH_USER}" != "" ]] && [[ "${APACHE_BASIC_AUTH_PASS}" != "" ]]; then
    echo "Enabling Basic HTTP Authentication [${APACHE_BASIC_AUTH_USER}:${APACHE_BASIC_AUTH_PASS}]"
    echo "${APACHE_BASIC_AUTH_USER}:$(echo ${APACHE_BASIC_AUTH_PASS} | mkpasswd -m md5)" >/etc/nginx/htpasswd
    echo "auth_basic \"Restricted area\";" >/etc/nginx/conf.d/basic-auth.conf
    echo "auth_basic_user_file htpasswd;" >>/etc/nginx/conf.d/basic-auth.conf
fi

