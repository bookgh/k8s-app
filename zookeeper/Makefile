PROJECT_URL=192.168.2.30/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/zookeeper
DOCKER_IMAGE_VERSION=3.4.14
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: debian push

ubuntu:
	docker build -f ./Dockerfile.ubuntu -t ${DOCKER_IMAGE}-ubuntu .

debian:
	docker build -f ./Dockerfile.debian -t ${DOCKER_IMAGE}-debian .

push: push
	docker push $(DOCKER_IMAGE)-debian

zookeeper.yaml: .zookeeper.yaml.in
	@cat .zookeeper.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)-debian|" \
		> zookeeper.yaml && echo "created $@"

start: zookeeper.yaml
	kubectl apply -f zookeeper.yaml

stop: zookeeper.yaml
	kubectl delete --ignore-not-found=true -f zookeeper.yaml

zk_shell:
	kubectl exec -it zookeeper-1 -- /zookeeper-$(DOCKER_IMAGE_VERSION)/bin/zkCli.sh

port:
	kubectl port-forward zookeeper-1 2181:2181

check:
	@echo srvr | nc localhost  2181

clean:
	@rm -fv zookeeper.yaml
