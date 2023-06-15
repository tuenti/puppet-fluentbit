define fluentbit::pipeline (
  Enum['input','filter','output'] $type,
  String[1]                       $plugin_name,
  Hash[String, Any]               $properties = {},
) {
  $db_settings = $type ? {
    'input' => {
      'db' => "${fluentbit::data_dir}/${title}",
    },
    default => {},
  }

  if $type == 'output' and $plugin_name == 'forward' {
    $upstream_settings = $properties['upstream'] ? {
      undef   => {},
      default => "${fluentbit::config_dir}/upstream-${properties['upstream']}.conf",
    }
  } else {
    $upstream_settings = {}
  }
  file { "${fluentbit::config::plugin_dir}/${title}.yaml":
    mode    => $fluentbit::config_file_mode,
    notify  => Service[$fluentbit::service_name],
    content => to_yaml(
      {
        'pipeline' => {
          "${type}s" => [
            merge(
              $db_settings,
              $properties,
              {
                'name' => $plugin_name
              }
            )
          ],
        },
      }
    ),
  }
}
