define wildfly::interface(
  $inet_type  = 'inet-address',
  $ip_address
) {
  augeas {"wildfly interface ${name}/${inet_type}":
    context => "${wildfly::install::aug_config}/server/interfaces",
    lens    => 'Xml.lns',
    incl    => "${wildfly::install::config_path}",
    changes => [
      "set interface[#attribute/name='${name}']/${inet_type}/#attribute/value ${ip_address}",
    ],
    require => Archive['wildfly'],
    notify  => Service['wildfly'],
  }
}

