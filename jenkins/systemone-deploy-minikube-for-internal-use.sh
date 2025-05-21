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

if [ -z "$1" ]; then
  echo "Usage: $0 <MINIKUBE_IP>"
  exit 1
fi

MINIKUBE_IP="$1"

URLS=(
  "http://$MINIKUBE_IP:30580"
  "http://$MINIKUBE_IP:30080"
  "http://$MINIKUBE_IP:30180"
  "http://$MINIKUBE_IP:30380"
)

MAX_ATTEMPTS=30
SLEEP_SECONDS=10

echo "Waiting for all URLs to become accessible..."

for URL in "${URLS[@]}"; do
  attempt=1
  while (( attempt <= MAX_ATTEMPTS )); do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
    if [ "$HTTP_CODE" == "200" ]; then
      echo "Success: $URL is accessible."
      break
    else
      echo "Attempt $attempt/$MAX_ATTEMPTS failed for $URL (HTTP $HTTP_CODE). Retrying in $SLEEP_SECONDS seconds..."
      (( attempt++ ))
      sleep $SLEEP_SECONDS
    fi
  done

  if (( attempt > MAX_ATTEMPTS )); then
    echo "Error: $URL did not become accessible after $MAX_ATTEMPTS attempts."
    exit 1
  fi
done

echo "All URLs are accessible. Continuing with the batch job..."