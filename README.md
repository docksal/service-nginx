# Nginx Docker images for Docksal

Nginx images based on the official Nginx images from Docker Hun (alpine flavor) with extra features. 

This image(s) is part of the [Docksal](http://docksal.io) image library.

## Versions

- docksal/nginx:1.20
- docksal/nginx:1.21

## Extra features

- SSL enabled (self-signed cert)
- HTTP Basic Authentication
- Configuration presets (`html`, `php`, `drupal`, `wordpress`)
- User configuration overrides

## Document root

Nginx server `root` can be set via `NGINX_SERVER_ROOT` environment variable (defaults to `/var/www/docroot`). 

## FastCGI server endpoint

These images are set up to work with a FastCGI server and will not start without one.  
The FastCGI endpoint can be set via `NGINX_FCGI_HOST_PORT` environment variable (defaults to `php-fpm:9000`).

## HTTP Basic Authentication

Use `NGINX_BASIC_AUTH_USER` and `NGINX_BASIC_AUTH_PASS` environment variables to set username and password.

Example with Docker Compose

```yaml
  ...
  environment:
    - NGINX_BASIC_AUTH_USER=user
    - NGINX_BASIC_AUTH_PASS=password
  ...
```

## Configuration presets

Configuration presets can be set using the `NGINX_VHOST_PRESET` environment variable (defaults to `html`).

Available options:

- `NGINX_VHOST_PRESET=html` - basic HTML site
- `NGINX_VHOST_PRESET=php` - generic PHP application
- `NGINX_VHOST_PRESET=drupal` - Drupal
- `NGINX_VHOST_PRESET=wordpress` - WordPress

## Configuration overrides

Configuration overrides can be added to a Docksal project codebase.

Use `.docksal/etc/nginx/vhost-overrides.conf` to override the default virtual host configuration, e.g.:

```
index index2.html;
```

Use `.docksal/etc/nginx/vhosts.conf` to define additional virtual hosts, e.g.:

```
server
{
    listen 80;
    server_name test3.docksal.site;
    root /var/www/docroot;
    index index3.html;
}
```
