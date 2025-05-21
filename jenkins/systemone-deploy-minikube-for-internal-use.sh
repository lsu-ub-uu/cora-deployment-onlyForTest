#!/bin/bash
helm uninstall systemone-internal -n systemone-internal

kubectl delete pv systemone-internal-postgres-volume
kubectl delete pv systemone-internal-archive-volume
kubectl delete pv systemone-internal-archive-read-only-volume
kubectl delete pv systemone-internal-converted-files-volume
kubectl delete pv systemone-internal-converted-files-read-only-volume

cd helm
kubectl create namespace systemone-internal
kubectl apply -f helm-systemone-minikube-persistent-volumes.yaml --namespace=systemone-internal
helm install systemone-internal systemone --namespace systemone-internal --set deployFitNesse=true