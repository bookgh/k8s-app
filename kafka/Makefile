NAME=kafka
VERSION=2.12-1.1.0
PROJECT_URL=192.168.2.30/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/$(NAME)
DOCKER_IMAGE_VERSION=$(VERSION)
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: debian push

ubuntu:
	docker build -f ./Dockerfile.ubuntu -t ${DOCKER_IMAGE}-ubuntu .

debian:
	docker build -f ./Dockerfile.debian -t ${DOCKER_IMAGE}-debian .

push: push
	docker push ${DOCKER_IMAGE}-debian

yaml: .${NAME}.yaml.in
	@cat .${NAME}.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)-debian|" \
		> ${NAME}.yaml && echo "created $@"

start: ${NAME}.yaml
	kubectl apply -f ${NAME}.yaml

stop: ${NAME}.yaml
	kubectl delete --ignore-not-found=true -f ${NAME}.yaml

port:
	kubectl port-forward ${NAME}-1 9099:9092

check:
	@echo srvr | nc localhost  9099

clean:
	@rm -fv ${NAME}.yaml

.PHONY: all debian push
