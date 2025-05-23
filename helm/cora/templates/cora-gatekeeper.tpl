{{- define "cora.gatekeeper" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.system.name }}-gatekeeper-deployment
  labels:
    app: {{ .Values.system.name }}-gatekeeper
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Values.system.name }}-gatekeeper
  template:
    metadata:
      labels:
        app: {{ .Values.system.name }}-gatekeeper
    spec:
      initContainers:
        {{- toYaml .Values.initContainers.waitForDb | nindent 6 }}
      initContainers:
        {{- toYaml .Values.initContainers.waitForMq | nindent 6 }}
      containers:
      - name: {{ .Values.system.name }}-gatekeeper
        image: {{ .Values.dockerRepository.url }}{{ .Values.dockers.gatekeeper }}
        ports:
        - containerPort: 8080
      imagePullSecrets:
      - name: cora-dockers
---
apiVersion: v1
kind: Service
metadata:
  name: gatekeeper
spec:
  selector:
    app: {{ .Values.system.name }}-gatekeeper
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
{{- end }}