{{/*
Expand the name of the chart.
*/}}
{{- define "poc-ccc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "poc-ccc.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "poc-ccc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "poc-ccc.labels" -}}
helm.sh/chart: {{ include "poc-ccc.chart" . }}
{{ include "poc-ccc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "poc-ccc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "poc-ccc.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "poc-ccc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "poc-ccc.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "poc-ccc.imagePullSecretsData" -}}
.dockerconfigjson: {{ printf "{\"auths\": {\"%s\": {\"username\": \"%s\", \"password\": \"%s\", \"email\": \"%s\"}}}" .Values.poccccMicroservice.imagePullSecrets.registry.server .Values.poccccMicroservice.imagePullSecrets.registry.username .Values.poccccMicroservice.imagePullSecrets.registry.password .Values.registry.email | b64enc }}
{{- end }}
