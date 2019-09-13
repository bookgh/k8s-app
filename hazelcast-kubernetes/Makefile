PROJECT_URL=192.168.2.30/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/hazelcast-kubernetes
DOCKER_IMAGE_VERSION=3.9.1
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: build push

build:
	docker build -f ./Dockerfile -t ${DOCKER_IMAGE} .

push: push
	docker push ${DOCKER_IMAGE}

hazelcast.yaml: .hazelcast.yaml.in
	@cat .hazelcast.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)|" \
		> hazelcast.yaml && echo "created $@"

start: hazelcast.yaml
	kubectl apply -f hazelcast.yaml

stop: hazelcast.yaml
	kubectl delete --ignore-not-found=true -f hazelcast.yaml

clean:
	@rm -fv hazelcast.yaml

.PHONY: all build push
