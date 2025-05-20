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

# List of URLs to check
HOST="192.168.49.2"
URLS=(
  "http://$HOST:30580"
  "http://$HOST:30080"
  "http://$HOST:30180"
  "http://$HOST:30380"
)

MAX_ATTEMPTS=30
SLEEP_SECONDS=10

echo "Waiting for all URLs to become accessible..."

for URL in "${URLS[@]}"; do
  attempt=1
  while (( attempt <= MAX_ATTEMPTS )); do
    if curl -s -o /dev/null -w "%{http_code}\n" "$URL" == 200 then
   # if curl --silent --head --fail "$URL" > /dev/null; then
      echo "Success: $URL is accessible."
      break
    else
      echo "Attempt $attempt/$MAX_ATTEMPTS failed for $URL. Retrying in $SLEEP_SECONDS seconds..."
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