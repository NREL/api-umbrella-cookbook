default[:nginx][:source][:modules] = [
  'nginx::headers_more_module',
  'nginx::http_echo_module',
  'nginx::http_realip_module',
  'nginx::http_stub_status_module',
  'nginx::x_rid_header_module',
]
