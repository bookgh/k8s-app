NAME=hadoop
VERSION=2.7.7
PROJECT_URL=192.168.2.30/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/$(NAME)
DOCKER_IMAGE_VERSION=$(VERSION)
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: build push

build:
	docker build -f ./Dockerfile -t ${DOCKER_IMAGE} .

push:
	docker push ${DOCKER_IMAGE}

yaml: .${NAME}.yaml.in
	@cat .${NAME}.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)|" \
		> ${NAME}.yaml && echo "created $@"

clean:
	@rm -f ${NAME}.yaml
