{{- $front := dict "title" .Title "date" (.Date.Format "2006-01-02T15:04:05-07:00") "draft" .Draft -}}
{{- with .Params.tags }}{{ $front = merge $front (dict "tags" .) }}{{ end -}}
{{- with .Params.categories }}{{ $front = merge $front (dict "categories" .) }}{{ end -}}
{{- with .Params.summary }}{{ $front = merge $front (dict "summary" .) }}{{ end -}}
+++
{{ transform.Remarshal "TOML" $front }}+++

{{ .RawContent }}
