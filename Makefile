-include tests/env_make

FROM ?= nginx:1.15.7-alpine
VERSION ?= 1.15

TAG ?= $(VERSION)
SOFTWARE_VERSION ?= $(VERSION)

REPO ?= docksal/nginx
NAME ?= docksal-nginx-$(VERSION)

.EXPORT_ALL_VARIABLES:

.PHONY: build test push shell run start stop logs clean release

build:
	docker build -t $(REPO):$(TAG) --build-arg FROM=$(FROM) .

test:
	tests/test.bats

push:
	docker push $(REPO):$(TAG)

shell: clean
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG) /bin/bash -li

run: clean
	docker run --rm --name $(NAME) -it $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

start: clean
	docker run -d --name $(NAME) $(PORTS) $(VOLUMES) $(ENV) $(REPO):$(TAG)

exec:
	docker exec $(NAME) /bin/bash -c "$(CMD)"

exec-it:
	docker exec -it $(NAME) /bin/bash -lic "$(CMD)"

stop:
	docker stop $(NAME)

logs:
	docker logs $(NAME)

clean:
	docker rm -f $(NAME) >/dev/null 2>&1 || true

release:
	@scripts/docker-push.sh

default: build
