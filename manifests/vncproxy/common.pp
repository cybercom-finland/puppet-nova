# == Class: nova::vncproxy::common
#
# [*vncproxy_host*]
#   (optional) The host of the VNC proxy server
#   Defaults to false
#
# [*vncproxy_protocol*]
#   (optional) The protocol to communicate with the VNC proxy server
#   Defaults to 'http'
#
# [*vncproxy_port*]
#   (optional) The port to communicate with the VNC proxy server
#   Defaults to '6080'
#
# [*vncproxy_path*]
#   (optional) The path at the end of the uri for communication with the VNC proxy server
#   Defaults to '/vnc_auto.html'
#
class nova::vncproxy::common (
  $vncproxy_host     = undef,
  $vncproxy_protocol = undef,
  $vncproxy_port     = undef,
  $vncproxy_path     = undef,
) {

  include ::nova::deps

  $vncproxy_host_real     = normalize_ip_for_uri(pick(
    $vncproxy_host,
    getvar('::nova::compute::vncproxy_host'),
    getvar('::nova::vncproxy::host'),
    false))
  $vncproxy_protocol_real = pick(
    $vncproxy_protocol,
    getvar('::nova::compute::vncproxy_protocol'),
    getvar('::nova::vncproxy::vncproxy_protocol'),
    'http')
  $vncproxy_port_real     = pick(
    $vncproxy_port,
    getvar('::nova::compute::vncproxy_port'),
    getvar('::nova::vncproxy::port'),
    6080)
  $vncproxy_path_real     = pick(
    $vncproxy_path,
    getvar('::nova::compute::vncproxy_path'),
    getvar('::nova::vncproxy::vncproxy_path'),
    '/vnc_auto.html')

  if ($vncproxy_host_real) {
    $vncproxy_base_url = "${vncproxy_protocol_real}://${vncproxy_host_real}:${vncproxy_port_real}${vncproxy_path_real}"
    # config for vnc proxy
    nova_config {
      'vnc/novncproxy_base_url': value => $vncproxy_base_url;
    }
  }
}
