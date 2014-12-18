#
#
class wildfly::params {

  $group   = 'wildfly'
  $user    = 'wildfly'
  $dirname = '/opt/wildfly'

  $service_file  = $::osfamily? {
    Debian  => 'wildfly-init-debian.sh.erb',
    RedHat  => 'wildfly-init-redhat.sh.erb',
    default => 'wildfly-init-redhat.sh.erb',
  }

  $mode              = 'standalone'
  $config            = 'standalone-full.xml'

  $java_opts = {
    'wildfly java -Xmx' => {
      subsetting => '-Xmx',
      value      => '1024m',
    },
    'wildfly java -Xms' => {
      subsetting => '-Xms',
      value      => '512m',
    },
    'wildfly java -XX:MaxPermSize' => {
      subsetting        => '-XX:MaxPermSize',
      value             => '=256m',
    }
  }

  $users_mgmt = {
    'wildfly' => {
      username => 'wildfly',
      password => '2c6368f4996288fcc621c5355d3e39b7',
    },
  }

}
