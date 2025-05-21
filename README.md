# cora-deployment

This repo hold helm scripts for systemone, alvin and Diva.

```bash
cd helm
kubectl create namespace systemone-internal
kubectl apply -f helm-systemone-minikube-persistent-volumes --namespace=systemone-internal
helm install my20250519systemone systemone --namespace systemone-internal
```