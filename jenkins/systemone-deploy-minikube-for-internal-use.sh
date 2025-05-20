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
URLS=(
  "http://175.18.0.15:30580"
  "http://175.18.0.15:30080"
  "http://175.18.0.15:30180"
  "http://175.18.0.15:30380"
)

MAX_ATTEMPTS=30
SLEEP_SECONDS=10

echo "Waiting for all URLs to become accessible..."

for URL in "${URLS[@]}"; do
  attempt=1
  while (( attempt <= MAX_ATTEMPTS )); do
    if curl --silent --head --fail "$URL" > /dev/null; then
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