#!/bin/bash

# deploy prometheus
helm install \
  --name monitor \
  --namespace monitoring \
  -f prom-settings.yaml \
  -f prom-alertsmanager.yaml \
  -f prom-alertrules.yaml \
  prometheus

# deploy grafana
helm install \
  --name grafana \
  --namespace monitoring \
  -f grafana-settings.yaml \
  -f grafana-dashboards.yaml \
  grafana

# deploy dingtalk-webhook
kubectl apply -f dingtalk-webhook.yaml
