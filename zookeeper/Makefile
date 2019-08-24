PROJECT_URL=192.168.0.75/k8s
DOCKER_IMAGE_NAME=$(PROJECT_URL)/zookeeper
DOCKER_IMAGE_VERSION=3.4.14
DOCKER_IMAGE=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_VERSION)-debian


build_docker_image:
	docker build --force-rm=true -t $(DOCKER_IMAGE) .

push_to_registry:
	docker push $(DOCKER_IMAGE)

zookeeper.yaml: zookeeper.yaml.in
	@cat zookeeper.yaml.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)|" \
		> zookeeper.yaml && echo "created $@"

zookeeper.json: zookeeper.json.in
	@cat zookeeper.json.in | sed \
		-e  "s|%DOCKER_IMAGE%|$(DOCKER_IMAGE)|" \
		> zookeeper.json && echo "created $@"

start_zookeeper: zookeeper.json
	kubectl apply -f zookeeper.json
stop_zookeeper: zookeeper.json
	kubectl delete --ignore-not-found=true -f zookeeper.json

zk_shell:
	kubectl exec -it zookeeper-1 -- /zookeeper-$(DOCKER_IMAGE_VERSION)/bin/zkCli.sh

port_forward_zk:
	kubectl port-forward zookeeper-1 2181:2181

check:
	@echo srvr | nc localhost  2181

clean:
	@rm -fv zookeeper.json
