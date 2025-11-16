{{- /* Single term page (e.g. /tags/foo/) markdown view */ -}}
{{- $front := dict "title" .Title -}}
+++
{{ transform.Remarshal "TOML" $front }}+++

# {{ .Title }}

{{- $pages := .Pages }}
{{- if $pages }}
{{- range $pages.ByDate.Reverse }}
- [{{ .LinkTitle }}]({{ .RelPermalink }}) ({{ .Date.Format "2006-01-02" }})
{{- end }}
{{- else }}
_No pages._
{{- end }}
