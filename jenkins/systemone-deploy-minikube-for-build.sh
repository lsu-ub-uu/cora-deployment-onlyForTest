#!/bin/bash
helm uninstall systemone-build -n systemone-build

kubectl delete pv systemone-build-postgres-volume
kubectl delete pv systemone-build-archive-volume
kubectl delete pv systemone-build-archive-read-only-volume
kubectl delete pv systemone-build-converted-files-volume
kubectl delete pv systemone-build-converted-files-read-only-volume

cd helm
kubectl create namespace systemone-build
kubectl apply -f helm-systemone-build-minikube-persistent-volumes.yaml --namespace=systemone-build
helm install systemone-build systemone --namespace systemone-build -f ./jenkins/build-values.yaml