# cora-deployment

```bash
cd helm
kubectl create namespace helm-systemone
kubectl apply -f helm-systemone-minikube-persistent-volumes.yaml --namespace=helm-systemone
helm install my20250519systemone systemone --namespace helm-systemone
```