define wildfly::port(
  $protocol  = $name,
  $attribute = 'port',
  $value
) {
  augeas {"wildfly socket ${protocol}/${attribute}":
    context => "${wildfly::install::aug_config}/server/socket-binding-group[#attribute/name='standard-sockets']",
    lens    => 'Xml.lns',
    incl    => "${wildfly::install::config_path}",
    changes => [
      "set socket-binding[#attribute/name='${name}']/#attribute/${attribute} ${value}",
    ],
    require => Archive['wildfly'],
    notify  => Service['wildfly'],
  }
}
