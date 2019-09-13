NAME=zookeeper
VERSION=3.4.14
PROJECT_URL=192.168.0.75/kubernetes
DOCKER_IMAGE_NAME=$(PROJECT_URL)/$(NAME)
DOCKER_IMAGE_VERSION=$(VERSION)
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)

all: debian push

ubuntu:
	docker build -f ./Dockerfile.ubuntu -t ${DOCKER_IMAGE}-ubuntu .

debian:
	docker build -f ./Dockerfile.debian -t ${DOCKER_IMAGE}-debian .

push: push
	docker push $(DOCKER_IMAGE)-debian

yaml: .${NAME}.yaml.in
	@cat .${NAME}.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)-debian|" \
		> ${NAME}.yaml && echo "created $@"

start: ${NAME}.yaml
	kubectl apply -f ${NAME}.yaml

stop: ${NAME}.yaml
	kubectl delete --ignore-not-found=true -f ${NAME}.yaml

zk_shell:
	kubectl exec -it ${NAME}-1 -- /${NAME}-$(DOCKER_IMAGE_VERSION)/bin/zkCli.sh

port:
	kubectl port-forward ${NAME}-1 2181:2181

check:
	@echo srvr | nc localhost  2181

clean:
	@rm -fv ${NAME}.yaml
