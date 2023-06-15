define fluentbit::upstream(
  String[1]            $upstream_name = $name,
  Hash[String, String] $nodes,
) {
  file { "${fluentbit::config_dir}/upstream-${upstream_name}.conf":
    ensure  => present,
    mode    => '0640',
    content => epp('fluentbit/upstream.conf.epp',
      {
        'name'  => $upstream_name,
        'nodes' => $nodes,
      },
    ),
  }
}
