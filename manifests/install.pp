#
#
class wildfly::install(
  $version           = '8.1.0',
  $install_source    = undef,
  $install_file      = undef,
  $install_base      = undef,
  $java_home         = undef,
  $group             = $wildfly::params::group,
  $user              = $wildfly::params::user,
  $dirname           = $wildfly::params::dirname,
  $service_file      = $wildfly::params::service_file,
  $mode              = $wildfly::params::mode,
  $config            = $wildfly::params::config,
  $java_opts         = $wildfly::params::java_opts
) inherits wildfly::params  {

  group { $group :
    ensure => present,
  }

  user { $user :
    ensure     => present,
    groups     => $group,
    shell      => '/bin/bash',
    home       => "/home/${user}",
    comment    => "${user} user created by Puppet",
    managehome => true,
    require    => Group[$group],
  }

  $libaiopackage  = $::osfamily ? {
    'RedHat' => 'libaio',
    'Debian' => 'libaio1',
    default  => 'libaio',
  }

  if !defined(Package[$libaiopackage]) {
    package { $libaiopackage:
      ensure => present,
    }
  }

  $dirname_dir = dirname($dirname)

  file {"${dirname_dir}/${install_base}":
    ensure                  => 'directory', 
    owner                   => $user,
    group                   => $group,
    recurse                 => true,
    purge                   => false,
    selinux_ignore_defaults => true,
    require                 => Archive['wildfly'],
  }

  include 'archive'

  archive {"wildfly":
    path    => "/tmp/${install_file}",
    ensure  => 'present',
    extract => true,
    extract_path => "${dirname_dir}",
    creates => "${dirname_dir}/${install_base}",
    source  => "${install_source}",
    cleanup => true,
  }

  file {"${dirname}":
    ensure => "link",
    target => "${dirname_dir}/${install_base}",
    require => Archive['wildfly'],
  }

  $java_opts_ini_setting_defaults = {
    ensure            => 'present',
    path              => "${dirname}/bin/standalone.conf",
    section           => '',
    setting           => 'JAVA_OPTS',
    key_val_separator => '=',
    notify            => Service['wildfly'],
    require           => [File[$dirname],Archive['wildfly']],
    notify            => Service['wildfly'],
  }

  create_resources(ini_subsetting, $java_opts, $java_opts_ini_setting_defaults)

  $config_path = "${dirname_dir}/${install_base}/standalone/configuration/${config}"

  $aug_config = "/files${config_path}"

  file{"${dirname_dir}/${install_base}/standalone/configuration/mgmt-users.properties":
    ensure  => present,
    mode    => '0755',
    owner   => $user,
    group   => $group,
    content => template('wildfly/mgmt-users.properties.erb'),
    require => [Archive['wildfly'],File[$dirname]],
    notify  => Service['wildfly'],
  }

  file{'/etc/init.d/wildfly':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template("wildfly/${service_file}"),
  }

  file{'/etc/default/wildfly':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    content => template('wildfly/wildfly.conf.erb'),
  }

  service { 'wildfly':
    ensure    => true,
    name      => 'wildfly',
    enable    => true,
    subscribe => [File['/etc/init.d/wildfly','/etc/default/wildfly',$dirname],Archive['wildfly']],
  }

}
