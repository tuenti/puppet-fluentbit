type Fluentbit::MultilineParserRule = Struct[{
  state      => String[1],
  regex      => String[1],
  next_state => String[1],
}]
