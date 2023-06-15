# @summary Installs and configures fluentbit
#
# @example
#   include fluentbit
# @see https://docs.fluentbit.io/manual/
#
# @param manage_package_repo Installs the package repositories
# @param service_name the td-agent-bit service name
# @param input_plugins Hash of the INPUT plugins to be configured
# @param output_plugins Hash of the OUTPUT plugins to be configured
# @param filter_plugins Hash of the filter to be configured
#
# @param repo_key_fingerprint
#   GPG key identifier of the repository
#
# @param repo_key_location
#   GPG key location
#
# @param package_ensure
#   Whether to install the Fluentbit package, and what version to install.
#   Values: 'present', 'latest', or a specific version number.
#   Default value: 'present'.
#
# @param package_name
#   Specifies the Fluentbit package to manage.
#   Default value: 'td-agent-bit'
#
# @param manage_service
#   Whether to manage the service at all.
#   Default value: true
#
# @param service_enable
#   Whether to enable the fluentbit service at boot.
#   Default value: true.
#
# @param service_ensure
#   Whether the fluentbit service should be running.
#   Default value: 'running'.
#
# @param service_has_status
#   Whether the service has a functional status command.
#   Default value: true.
#
# @param service_has_restart
#   Whether the service has a restart command.
#   Default value: true.
#
# @param service_restart_command
#   Optional command for restarting service
#
# @param manage_config_dir
#   Whether to manage the configuration directory.
#   When enabled, will remove all unmanaged files from the directory the
#   configuration resides in.
#   Default value: true

# @param manage_data_dir
#   Whether to manage the data directory.
#   Default value: true

# @param manage_storage_dir
#   Whether to manage the storage directory. `storage_path` must be defined.
#   Default value: true
#
# @param data_dir
#   Path to data directory that will be used by plugins using DB feature.
#
# @param binary_file
#   Path of the daemon binary.
#
# @param config_file
#   Path of the daemon configuration.
#
# @param config_file_mode
#   File mode to apply to the daemon configuration file
#
# @param storage_path
#   Set an optional location in the file system to store streams and chunks of data.
#   If this parameter is not set, Input plugins can only use in-memory buffering.
#
# @param storage_sync
#   Configure the synchronization mode used to store the data into the file system.
#   It can take the values normal or full.
#   Default value: 'normal'
#
# @param storage_checksum
#   Enable the data integrity check when writing and reading data from the filesystem.
#   The storage layer uses the CRC32 algorithm.
#   Default value: false
#
# @param storage_backlog_mem_limit
#   If the input plugin has enabled filesystem storage type, this property sets the maximum 
#   number of Chunks that can be up in memory.
#   This is the setting to use to control memory usage when you enable storage.type filesystem.
#   Default value: 128
#
# @param storage_max_chunks_up
#   If storage.path is set, Fluent Bit will look for data chunks that were
#   not delivered and are still in the storage layer, these are called backlog data.
#   This option configure a hint of maximum value of memory to use when processing these records.
#   Default value: 5M
#
# @param storage_metrics
#   If http_server option has been enabled in the main [SERVICE] section, this option registers a new 
#   endpoint where internal metrics of the storage layer can be consumed.
#   Default value: false
#
# @param storage_delete_irrecoverable_chunks
#   When enabled, irrecoverable chunks will be deleted during runtime, and any other irrecoverable chunk 
#   located in the configured storage path directory will be deleted when Fluent-Bit starts.
#   Default value: false
#
# @param manage_plugins_file
#   Whether to manage the enabled external plugins
#
# @param plugins_file
#   A plugins configuration file allows to define paths for external plugins.
#
# @param plugins
#   List of external plugin objects to enable
#
# @param manage_streams_file
#   Whether to manage the stream processing configuration
#
# @param streams_file
#   Path for the Stream Processor configuration file.
#
# @param streams
#   Stream processing tasks
#
# @param upstreams
#   Upstreams used by forward plugins
#
# @param manage_parsers_file
#   Whether to manage the parser definitions
#
# @param parsers_file
#   Path for a parsers configuration file. Multiple Parsers_File entries can be used.
#
# @param parsers
#   List of parser definitions.
#   The default value consists of all the available definitions provided by the
#   upstream project as of version 1.3
#
# @param flush
#   Set the flush time in seconds. Everytime it timeouts, the engine will flush the records to the output plugin.
# @param grace
#   Set the grace time in seconds. The engine loop uses a Grace timeout to define the wait time on exit.
# @param daemon
#   Boolean value to set if Fluent Bit should run as a Daemon (background) or not. Allowed values are: yes, no, on and off.
# @param dns_mode
#   Sets the primary transport layer protocol used by the asynchronous DNS resolver.
# @param log_level
#   Set the logging verbosity level.
#   Values are: error, info, debug and trace. Values are accumulative,
#   e.g: if 'debug' is set, it will include error, info and debug.
#   Note that trace mode is only available if Fluent Bit was built with the WITH_TRACE option enabled.
# @param http_server
#   Enable built-in HTTP Server
# @param http_listen
#   Set listening interface for HTTP Server when it's enabled
# @param http_port
#   Set TCP Port for the HTTP Server
# @param coro_stack_size
#   Set the coroutines stack size in bytes.
#   The value must be greater than the page size of the running system.
# @param scheduler_cap
#   Set a maximum retry time in seconds. The property is supported from v1.8.7.
# @param scheduler_base
#   Sets the base of exponential backoff. The property is supported from v1.8.7.
# @param json_convert_nan_to_null
#   If enabled, NaN is converted to null when fluent-bit converts msgpack to json.
#
# @param variables
#   macro definitions to use in the configuration file
#   the will be registered using the *@SET* command or using Env section in YAML syntax.
#
class fluentbit (
  Boolean $manage_package_repo,
  Stdlib::HTTPUrl $repo_key_location,
  String[1] $repo_key_fingerprint,
  String[1] $package_ensure,
  String[1] $package_name,
  Boolean $manage_service,
  Boolean $service_enable,
  Boolean $service_has_status,
  Optional[String[1]] $service_restart_command,
  Boolean $service_has_restart,
  Stdlib::Ensure::Service $service_ensure,
  String[1] $service_name,
  Boolean $manage_config_dir,
  Boolean $manage_data_dir,
  Boolean $manage_storage_dir,

  Hash[String, Fluentbit::Plugin] $input_plugins,
  Hash[String, Fluentbit::Plugin] $output_plugins,
  Hash[String, Fluentbit::Plugin] $filter_plugins,

  Hash[String, Fluentbit::Parser] $parsers,
  Hash[String, Fluentbit::Stream] $streams,
  Hash[String, Hash] $upstreams,
  Array[Stdlib::Absolutepath] $plugins,

  Stdlib::Absolutepath $binary_file,
  Stdlib::Absolutepath $data_dir,
  Stdlib::Absolutepath $config_file,
  Stdlib::Filemode $config_file_mode,
  Integer $flush,
  Integer $grace,
  Boolean $daemon,
  Enum['UDP', 'TCP'] $dns_mode,
  Enum['error', 'warning', 'info', 'debug', 'trace'] $log_level,
  Boolean $manage_parsers_file,
  Stdlib::Absolutepath $parsers_file,
  Boolean $manage_plugins_file,
  Stdlib::Absolutepath $plugins_file,
  Boolean $manage_streams_file,
  Stdlib::Absolutepath $streams_file,
  Boolean $http_server,
  Stdlib::IP::Address::Nosubnet $http_listen,
  Stdlib::Port $http_port,
  Integer $scheduler_cap,
  Integer $scheduler_base,
  Boolean $json_convert_nan_to_null,

  Optional[Stdlib::Absolutepath] $storage_path,
  Optional[Enum['normal', 'full']] $storage_sync,
  Boolean $storage_checksum,
  Optional[Integer] $storage_max_chunks_up,
  Boolean $storage_metrics,
  Boolean $storage_delete_irrecoverable_chunks,
  Optional[String[1]] $storage_backlog_mem_limit,

  Hash $variables,
  Integer $coro_stack_size,
) {
  contain fluentbit::repo
  contain fluentbit::install
  contain fluentbit::config
  contain fluentbit::service

  Class['::fluentbit::repo']
  -> Class['::fluentbit::install']
  -> Class['::fluentbit::config']
  ~> Class['::fluentbit::service']

  create_resources(fluentbit::pipeline, $input_plugins, { type => 'input' })
  create_resources(fluentbit::pipeline, $output_plugins, { type => 'output' })
  create_resources(fluentbit::pipeline, $filter_plugins, { type => 'filter' })
  create_resources(fluentbit::upstream, $upstreams)
}
