#!/bin/bash
set -e
#docker build -t boykoalex/code-server-samples .
#docker push boykoalex/code-server-samples
kubectl delete -f resources/workshop.yaml
kubectl delete -f resources/training-portal.yaml
kubectl apply -f resources/workshop.yaml
kubectl apply -f resources/training-portal.yaml
watch kubectl get eduk8s
