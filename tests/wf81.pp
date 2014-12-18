class {'wildfly::install':
  version        => '8.1.0',
  install_source => 'http://download.jboss.org/wildfly/8.1.0.Final/wildfly-8.1.0.Final.tar.gz',
  install_file   => 'wildfly-8.1.0.Final.tar.gz',
  install_base   => 'wildfly-8.1.0.Final',
  config         => 'standalone-full-ha.xml',
  java_home      => '/usr/java/jre1.7.0_72',
}

wildfly::port{'ajp':
  value => '8009',
}

wildfly::port{'http':
  value => '8080',
}

wildfly::port{'https':
  value => '8444',
}

wildfly::port{'jgroups-mping':
  attribute => 'multicast-address',
  value     => '230.0.0.23',
}

wildfly::port{'jgroups-udp':
  attribute => 'multicast-address',
  value     => '230.0.0.23',
}

wildfly::port{'messaging-group':
  attribute => 'multicast-address',
  value     => '230.0.0.99',
}

wildfly::port{'modcluster':
  attribute => 'multicast-address',
  value     => '224.0.1.215',
}

wildfly::port{'management-http':
  value => '9990',
}

wildfly::interface{'management':
  ip_address => '0.0.0.0'
}

wildfly::interface{'public':
  ip_address => '0.0.0.0'
}

wildfly::interface{'unsecure':
  ip_address => '0.0.0.0'
}
