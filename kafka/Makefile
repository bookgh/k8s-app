PROJECT_URL=192.168.2.30/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/kafka
DOCKER_IMAGE_VERSION=2.12-1.1.0
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: debian push

ubuntu:
	docker build -f ./Dockerfile.ubuntu -t ${DOCKER_IMAGE}-ubuntu .

debian:
	docker build -f ./Dockerfile.debian -t ${DOCKER_IMAGE}-debian .

push: push
	docker push ${DOCKER_IMAGE}-debian

kafka.yaml: .kafka.yaml.in
	@cat .kafka.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)-debian|" \
		> kafka.yaml && echo "created $@"

start: kafka.yaml
	kubectl apply -f kafka.yaml

stop: kafka.yaml
	kubectl delete --ignore-not-found=true -f kafka.yaml

port:
	kubectl port-forward kafka-1 9099:9092

check:
	@echo srvr | nc localhost  9099

clean:
	@rm -fv kafka.yaml

.PHONY: all debian push
