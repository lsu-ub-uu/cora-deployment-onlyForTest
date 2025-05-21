#!/bin/bash

NAMESPACE="systemone-build"

echo ""
echo "Uninstalling Helm release '$NAMESPACE' from namespace '$NAMESPACE'..."
helm uninstall $NAMESPACE -n $NAMESPACE

echo ""
echo "Deleting Kubernetes namespace '$NAMESPACE'..."
kubectl delete namespace $NAMESPACE

echo ""
echo "Deleting persistent volumes for '$NAMESPACE'..."
kubectl delete pv ${NAMESPACE}-postgres-volume
kubectl delete pv ${NAMESPACE}-archive-volume
kubectl delete pv ${NAMESPACE}-archive-read-only-volume
kubectl delete pv ${NAMESPACE}-converted-files-volume
kubectl delete pv ${NAMESPACE}-converted-files-read-only-volume

echo ""
echo "Removing local persistent data from /mnt/minikube/systemone/build..."
rm -rf /mnt/minikube/systemone/build

echo ""
echo "Check everything is deleted"
ls /mnt/minikube/systemone/build
kubectl get node,pods,pv,pvc,all -A -o wide

echo ""
echo "Creating namespace '$NAMESPACE'..."
cd helm
kubectl create namespace $NAMESPACE

echo ""
echo "Applying persistent volume definitions from 'helm-${NAMESPACE}-minikube-persistent-volumes.yaml'..."
kubectl apply -f helm-${NAMESPACE}-minikube-persistent-volumes.yaml --namespace=$NAMESPACE

echo ""
echo "Installing Helm chart 'systemone' as release '$NAMESPACE' in namespace '$NAMESPACE'..."
helm install $NAMESPACE systemone --namespace $NAMESPACE -f ../jenkins/build-values.yaml

echo ""
echo "Waiting for all pods in '$NAMESPACE' namespace to become ready (timeout: 300s)..."
kubectl wait --for=condition=Ready pod --all --namespace=$NAMESPACE --timeout=300s

echo "Deployment of $NAMESPACE completed successfully."