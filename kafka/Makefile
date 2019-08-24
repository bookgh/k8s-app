PROJECT_URL=192.168.0.75/k8s
DOCKER_IMAGE_NAME=$(PROJECT_URL)/kafka
DOCKER_IMAGE_VERSION=2.12-1.1.0
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: debian

ubuntu:
	docker build -f ./Dockerfile.ubuntu -t ${DOCKER_IMAGE}-ubuntu .

debian:
	docker build -f ./Dockerfile.debian -t ${DOCKER_IMAGE}-debian .


push: build
	gcloud docker -- push ${DOCKER_IMAGE}

.PHONY: all build push
