PROJECT_URL=192.168.0.75/library
DOCKER_IMAGE_NAME=$(PROJECT_URL)/fastdfs-compose
DOCKER_IMAGE_VERSION=5.11
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: build push

build:
	docker build -f ./Dockerfile -t ${DOCKER_IMAGE} .

push:
	docker push ${DOCKER_IMAGE}

clean:
	docker rmi ${DOCKER_IMAGE}
