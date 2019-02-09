#!/usr/bin/env bash

# Verify nginx config is valid
nginx -t

# Verify default vhost it up
wget -qSO- http://127.0.0.1/.healthz
