# cora-deployment

This repo hold helm scripts for systemone, alvin and Diva.


## Run locally using minicube, with fitnesse and jsclient

start minikube, adjust as needed

```bash
minikube start --memory 32192 --cpus 16 --mount --mount-string "/mnt/someplace/minikube/:/mnt/minikube"
```

```bash
cd helm
kubectl create namespace helm-systemone
kubectl apply -f helm-systemone-minikube-persistent-volumes.yaml
helm install my20250521systemone systemone --namespace helm-systemone --set deploy.fitnesse=true
```
you can watch the progress with:

```bash
watch -n 1 kubectl get pod,service -n helm-systemone
```

get your minikube ip: minikube ip


This should start a local version of systemOne accessable at:<br>
* rest: http://192.168.49.2:30080/systemone/rest/
* login: localhost:30180/
* jsClient: http://192.168.49.2:30280/jsclient/
* idplogin: localhost:30380/login
* fitnesse: http://192.168.49.2:30580/fitnesse/


## to remove and start over
```bash
helm uninstall -n helm-systemone my20250521systemone
kubectl delete $(kubectl get pv -o name | grep '^persistentvolume/helm-systemone')
kubectl delete namespace helm-systemone
minikube ssh -- "sudo rm -rf /mnt/minikube/systemone/"
```