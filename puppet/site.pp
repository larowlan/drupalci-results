# The node definition.

node default {

  include yum::repo::remi_php56
  include mysql::server
  include mysql::server::mysqltuner
  include mysql::client
  include mysql::bindings

  ##
  # PHP.
  ##

  package {[
    'php-common',
    'php-cli',
    'perl-WWW-Curl',
    'php-mcrypt',
    'php-pear',
    'nmap',
  ]:
    ensure => 'latest',
  }

  class { 'composer':
    command_name => 'composer',
    target_dir   => '/usr/local/bin'
  }

  ##
  # Apache.
  ##

  class { 'apache':
    default_vhost => false,
    mpm_module    => 'prefork',
  }
  apache::listen { '80': }
  include apache::mod::rewrite
  include apache::mod::php

  apache::vhost { $fqdn:
    docroot          => '/var/www/results/current/app',
    manage_docroot   => false,
    priority         => '25',
    override         => [ 'ALL' ],
  }

  mysql::db { 'drupal':
    user     => 'drupal',
    password => 'drupal',
    host     => 'localhost',
  }

}
