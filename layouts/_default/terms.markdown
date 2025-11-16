{{- /* Terms (e.g. /tags/) markdown view */ -}}
{{- $front := dict "title" .Title -}}
+++
{{ transform.Remarshal "TOML" $front }}+++

{{- if .Data.Terms }}
# {{ .Title }}

{{- range .Data.Terms.Alphabetical }}
{{- $name := .Name | default .Term }}
{{- $link := "" }}
{{- with .Page }}{{ $link = .RelPermalink }}{{ end }}
{{- if not $link }}{{ $link = printf "/%s/%s/" $.Data.Plural (.Term | urlize) }}{{ end }}
- [{{ $name }}]({{ $link }}) ({{ .Count }})
{{- end }}
{{- else }}
_No terms found._
{{- end }}
