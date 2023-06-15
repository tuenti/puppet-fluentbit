type Fluentbit::Plugin = Struct[{
  plugin_name          => String[1],
  type                 => String[1],
  Optional[properties] => Hash,
}]
