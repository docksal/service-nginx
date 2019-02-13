#!/bin/bash

set -e # Fail on errors

# Basic HTTP Authentication
if [[ "${NGINX_BASIC_AUTH_USER}" != "" ]] && [[ "${NGINX_BASIC_AUTH_PASS}" != "" ]]; then
	echo "Enabling Basic HTTP Authentication [${NGINX_BASIC_AUTH_USER}:${NGINX_BASIC_AUTH_PASS}]"
	echo "${NGINX_BASIC_AUTH_USER}:$(echo ${NGINX_BASIC_AUTH_PASS} | mkpasswd -m md5)" >/etc/nginx/htpasswd
	echo "auth_basic \"Restricted area\";" >/etc/nginx/conf.d/basic-auth.conf
	echo "auth_basic_user_file htpasswd;" >>/etc/nginx/conf.d/basic-auth.conf
fi
