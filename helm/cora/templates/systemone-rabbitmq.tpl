{{- define "cora.rabbitmq" -}}
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ .Values.system.name }}-rabbitmq-deployment
  labels:
    app: {{ .Values.system.name }}-rabbitmq
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Values.system.name }}-rabbitmq
  template:
    metadata:
      labels:
        app: {{ .Values.system.name }}-rabbitmq
    spec:
      containers:
      - name: {{ .Values.system.name }}-rabbitmq
        image: {{ .Values.dockerRepository.url }}{{ .Values.dockers.rabbitmq }}
        ports:
        - containerPort: 5672
      imagePullSecrets:
      - name: cora-dockers

---

apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.system.name }}-rabbitmq
spec:
  selector:
    app: {{ .Values.system.name }}-rabbitmq
  ports:
    - protocol: TCP
      port: 5672
      targetPort: 5672
{{- end }}