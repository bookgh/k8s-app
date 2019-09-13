PROJECT_URL=192.168.2.30/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/fastdfs
DOCKER_IMAGE_VERSION=5.11
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: build push

build:
	docker build -f ./Dockerfile -t ${DOCKER_IMAGE} .

push:
	docker push ${DOCKER_IMAGE}

fastdfs.yaml: .fastdfs.yaml.in
	@cat .fastdfs.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)|" \
		> fastdfs.yaml && echo "created $@"

clean:
	@rm -f fastdfs.yaml
