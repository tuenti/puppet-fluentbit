type Fluentbit::Plugin = Struct[{
  plugin_name          => String[1],
  Optional[type]       => Enum['input', 'output', 'filter'],
  Optional[properties] => Hash,
}]
