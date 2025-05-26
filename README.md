# cora-deployment

This repo hold helm charts for systemOne, Alvin and DiVA.

start minikube, adjust as needed

```bash
minikube start --memory 32192 --cpus 16 --mount --mount-string "/mnt/someplace/minikube/:/mnt/minikube"
```

## Run systemOne locally using minicube, with fitnesse and jsclient

```bash
cd helm
kubectl create namespace systemone
kubectl apply -f systemone-minikube-persistent-volumes.yaml
helm install my20250523systemone systemone --namespace systemone --set deploy.fitnesse=true
```
you can watch the progress with:

```bash
watch -n 1 kubectl get pod,service -n systemone
```

get your minikube ip: minikube ip


This should start a local version of systemOne accessable at:<br>
* rest: http://192.168.49.2:30080/systemone/rest/
* login: localhost:30180/
* jsClient: http://192.168.49.2:30280/jsclient/
* idplogin: localhost:30380/login
* fitnesse: http://192.168.49.2:30580/systemone/fitnesse/


### to remove and start over
```bash
helm uninstall -n systemone my20250523systemone
kubectl get pv -o name | grep "^persistentvolume/systemone | xargs -r kubectl delete
kubectl delete namespace systemone
minikube ssh -- "sudo rm -rf /mnt/minikube/systemone/"
```

## Run Alvin locally using minicube, with fitnesse and jsclient

```bash
cd helm
kubectl create namespace alvin
kubectl apply -f alvin-minikube-persistent-volumes.yaml
helm install my20250526alvin alvin --namespace alvin --set deploy.fitnesse=true
```
you can watch the progress with:

```bash
watch -n 1 kubectl get pod,service -n alvin
```

get your minikube ip: minikube ip


This should start a local version of diva accessable at:<br>
* rest: http://192.168.49.2:30081/alvin/rest/
* login: localhost:30181/
* jsClient: http://192.168.49.2:30281/jsclient/
* idplogin: localhost:30381/login
* fitnesse: http://192.168.49.2:30581/alvin/fitnesse/


### to remove and start over
```bash
helm uninstall -n diva my20250526alvin
kubectl get pv -o name | grep "^persistentvolume/alvin | xargs -r kubectl delete
kubectl delete namespace alvin
minikube ssh -- "sudo rm -rf /mnt/minikube/alvin/"
```


## Run DiVA locally using minicube, with fitnesse and jsclient

```bash
cd helm
kubectl create namespace diva
kubectl apply -f diva-minikube-persistent-volumes.yaml
helm install my20250523diva diva --namespace diva --set deploy.fitnesse=true
```
you can watch the progress with:

```bash
watch -n 1 kubectl get pod,service -n diva
```

get your minikube ip: minikube ip


This should start a local version of diva accessable at:<br>
* rest: http://192.168.49.2:30082/diva/rest/
* login: localhost:30182/
* jsClient: http://192.168.49.2:30282/jsclient/
* idplogin: localhost:30382/login
* fitnesse: http://192.168.49.2:30582/diva/fitnesse/


### to remove and start over
```bash
helm uninstall -n diva my20250523diva
kubectl get pv -o name | grep "^persistentvolume/diva | xargs -r kubectl delete
kubectl delete namespace diva
minikube ssh -- "sudo rm -rf /mnt/minikube/diva/"
```


