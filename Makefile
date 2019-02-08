-include env_make

VERSION ?= 1.15

TAG ?= $(VERSION)
REPO ?= docksal/nginx
PORTS = -p 2580:80 -p 25443:443
#VOLUMES = -v `pwd`/tests/docroot:/var/www/docroot -v `pwd`/tests/config:/var/www/.docksal/etc/nginx
#ENV = -e APACHE_BASIC_AUTH_USER=user -e APACHE_BASIC_AUTH_PASS=123

NAME = docksal-nginx-$(VERSION)

ifneq ($(STABILITY_TAG),)
    ifneq ($(TAG),latest)
        override TAG := $(TAG)-$(STABILITY_TAG)
    endif
endif

.PHONY: build test push shell run start stop logs clean release

build:
	docker build -t $(REPO):$(TAG) --build-arg VERSION=$(VERSION) .

test:
	IMAGE=$(REPO):$(TAG) NAME=$(NAME) VERSION=$(VERSION) bats ./tests/test.bats

push:
	docker push $(REPO):$(TAG)

shell:
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash

run:
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

start: clean
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

exec:
	docker exec $(NAME) /bin/bash -c "$(CMD)"

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	docker rm -f $(NAME) >/dev/null 2>&1 || true

release: build push

default: build
