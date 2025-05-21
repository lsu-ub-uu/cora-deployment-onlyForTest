#!/bin/bash
helm uninstall systemone-preview -n systemone-preview
kubectl delete namespace systemone-preview

kubectl delete pv systemone-preview-postgres-volume
kubectl delete pv systemone-preview-archive-volume
kubectl delete pv systemone-preview-archive-read-only-volume
kubectl delete pv systemone-preview-converted-files-volume
kubectl delete pv systemone-preview-converted-files-read-only-volume

rm -rf /mnt/minikube/systemone/preview

cd helm
kubectl create namespace systemone-preview
kubectl apply -f helm-systemone-preview-minikube-persistent-volumes.yaml --namespace=systemone-preview
helm install systemone-preview systemone --namespace systemone-preview

kubectl wait --for=condition=Ready pod --all --namespace=systemone-preview --timeout=300s