{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-helm-demo-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "k8s-helm-demo-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "k8s-helm-demo-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "k8s-helm-demo-chart.labels" -}}
helm.sh/chart: {{ include "k8s-helm-demo-chart.chart" . }}
{{ include "k8s-helm-demo-chart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "k8s-helm-demo-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-helm-demo-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Call the template of a subchart.
See https://github.com/helm/helm/issues/4535.
Usage: {{ include "k8s-helm-demo-chart.callSubchartTpl" (list . "subchartName" "subchartName.subchartTemplate") }}
*/}}
{{- define "k8s-helm-demo-chart.callSubchartTpl" }}
{{- $dot := index . 0 }}
{{- $subchart := index . 1 | splitList "." }}
{{- $template := index . 2 }}
{{- $values := $dot.Values }}
{{- range $subchart }}
{{- $values = index $values . }}
{{- end }}
{{- include $template (dict "Chart" (dict "Name" (last $subchart)) "Values" $values "Release" $dot.Release "Capabilities" $dot.Capabilities) }}
{{- end }}

