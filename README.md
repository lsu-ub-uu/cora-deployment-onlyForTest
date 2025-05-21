# cora-deployment

This repo hold helm scripts for systemone, alvin and Diva.


## Run locally with fitnesse and jsclient

```bash
cd helm
kubectl create namespace helm-systemone
kubectl apply -f helm-systemone-minikube-persistent-volumes --namespace helm-systemone
helm install my20250521systemone systemone --namespace helm-systemone --set deploy.fitnesse=true
```

This should start a local version of systemOne accessable at:<br>
* rest: localhost:30080/rest
* login: localhost:30180/
* jsClient: localhost:30280/jsclient
* idplogin: localhost:30380/login
* fitnesse: localhost:30580/fitnesse