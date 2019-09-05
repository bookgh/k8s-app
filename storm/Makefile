PROJECT_URL=192.168.2.30/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/storm
DOCKER_IMAGE_VERSION=1.2.2
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: build push

build:
	docker build -f ./Dockerfile -t ${DOCKER_IMAGE} .

push:
	docker push ${DOCKER_IMAGE}

storm.yaml: .storm.yaml.in
	@cat .storm.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)|" \
		> storm.yaml && echo "created $@"
