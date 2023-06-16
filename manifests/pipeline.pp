# @summary Configures fluentbit pipeline (input, output or filter)
#
# @note This resource add extra configuration elements for some combinations of
#  type-plugin_names, like db configuration for input plugins, or upstream configuration
#  for output-forward plugin
#
# @example
#   fluentbit::pipeline { 'input-dummy':
#     type        => 'input',
#     plugin_name => 'dummy',
#   }
# @example
#   fluentbit {
#     input_plugins => {
#       'input-dummy' => { 'plugin_name' => 'dummy' },
#     },
#   }
# @see https://docs.fluentbit.io/manual/administration/configuring-fluent-bit/yaml/configuration-file#config_pipeline
#
# @param type Defines the pipeline type to be configured
# @param plugin_name fluent-bit plugin name to be used
# @param properties Hash of rest of properties needed to configure the pipeline-plugin
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
      undef      => {},
      default    => {
        upstream => "${fluentbit::config::config_dir}/upstream-${properties['upstream']}.conf",
      },
    }
  } else {
    $upstream_settings = {}
  }
  file { "${fluentbit::config::plugin_dir}/${title}.conf":
    mode    => $fluentbit::config_file_mode,
    notify  => Service[$fluentbit::service_name],
    content => epp('fluentbit/pipeline.conf.epp',
      {
        name       => $plugin_name,
        type       => $type,
        properties => merge(
          $db_settings,
          $upstream_settings,
          $properties,
        )
      }
    ),
  }
}
