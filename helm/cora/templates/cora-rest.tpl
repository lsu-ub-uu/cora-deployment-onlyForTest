{{- define "cora.solr" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.system.name }}-rest-deployment
  labels:
    app: {{ .Values.system.name }}-rest
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Values.system.name }}-rest
  template:
    metadata:
      labels:
        app: {{ .Values.system.name }}-rest
    spec:
      initContainers:
        {{- toYaml .Values.initContainers.waitForDb | nindent 6 }}
      initContainers:
        {{- toYaml .Values.initContainers.waitForMq | nindent 6 }}
      containers:
      - name: {{ .Values.system.name }}-rest
        image: {{ .Values.dockerRepository.url }}{{ .Values.dockers.rest }}
        ports:
        - containerPort: 8080
        volumeMounts:
        - mountPath: "/mnt/data/basicstorage"
          name: converted-files-read-write
      volumes:
        - name: converted-files-read-write
          persistentVolumeClaim:
            claimName: {{ .Values.system.name }}-converted-files-read-write-volume-claim
      imagePullSecrets:
      - name: cora-dockers

---

apiVersion: v1
kind: Service
metadata:
  name: {{ .Values.system.name }}
spec:
  type: NodePort
  selector:
    app: {{ .Values.system.name }}-rest
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort: {{ .Values.port.rest }}
{{- end }}