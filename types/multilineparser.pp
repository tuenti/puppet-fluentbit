type Fluentbit::MultilineParser = Struct[{
  type                    => Enum['regex'],
  rule                    => Array[Fluentbit::MultilineParserRule],
  Optional[parser]        => String[1],
  Optional[key_content]   => String[1],
  Optional[flush_timeout] => String[1],
}]