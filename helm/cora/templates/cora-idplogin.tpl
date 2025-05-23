{{- define "cora.idplogin" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Values.system.name }}-idplogin-deployment
  labels:
    app: {{ .Values.system.name }}-idplogin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ .Values.system.name }}-idplogin
  template:
    metadata:
      labels:
        app: {{ .Values.system.name }}-idplogin
    spec:
      initContainers:
        {{- toYaml .Values.initContainer.waitForDb | nindent 6 }}
      containers:
      - name: {{ .Values.system.name }}-idplogin
        image: {{ .Values.dockerRepository.url }}{{ .Values.docker.idplogin }}
        ports:
        - containerPort: 8080
        env:
        - name: JAVA_OPTS
          value: -Dtoken.logout.url=http://login:8080/login/rest/authToken/
      imagePullSecrets:
      - name: cora-dockers

---

apiVersion: v1
kind: Service
metadata:
  name: idplogin
spec:
  type: NodePort
  selector:
    app: {{ .Values.system.name }}-idplogin
  ports:
    - protocol: TCP
      port: 8080
      targetPort: 8080
      nodePort:  {{ .Values.port.idplogin }}
{{- end -}}
