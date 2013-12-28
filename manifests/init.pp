class php {

  # Packages
  # ==========================================================================

  $php_package_require = $operatingsystem ? {
    Ubuntu  => Apt::Ppa['ppa:ondrej/php5'],
    default => undef,
  }

  package { 'php':
    name   => [
      'php5-cli',
      'php5-fpm',
      'php5-dev',
    ],
    ensure  => $operatingsystem ? {
      Ubuntu  => '5.4.17-1~precise+1',
      default => 'latest',
    },
    require => $php_package_require,
  }

  package { 'php-library':
    name   => [
      'php-apc',
      'php-pear',
      'php5-curl',
      'php5-gd',
      'php5-imagick',
      'php5-mcrypt',
      'php5-memcached',
      'php5-mysql',
      'php5-pgsql',
      'php5-sqlite',
      'php5-xdebug',
      'phpunit',
    ],
    ensure  => 'installed',
    require => Package['php'],
  }

  if ! defined( Package['sqlite'] ){
    package { 'sqlite':
      ensure => 'present',
    }
  }

  # Service
  # ==========================================================================

  service { 'php':
    name      => 'php5-fpm',
    ensure    => 'running',
    enable    => 'true',
    pattern   => 'php-fpm',
    subscribe => [
      Package['php'],
      File['php.ini'],
      File['php-fpm.conf'],
      File['www.conf'],
    ],
  }

  # Files
  # ==========================================================================
  # Note: the 'files' dir is ommitted when using puppet:///.

  if ! defined(File['/etc/apt/sources.list.d/']) {
    file { '/etc/apt/sources.list.d/':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  file { 'php.ini':
    path    => '/etc/php5/fpm/php.ini',
    source  => 'puppet:///modules/php/php.ini',
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['php'],
  }

  file { 'cli-php.ini':
    path    => '/etc/php5/cli/php.ini',
    source  => 'puppet:///modules/php/php.ini',
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => [
      File['php.ini'],
      Package['php'],
    ],
  }

  file { 'php-fpm.conf':
    path    => '/etc/php5/fpm/php-fpm.conf',
    source  => 'puppet:///modules/php/php-fpm.conf',
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['php'],
  }

  file { 'www.conf':
    path    => '/etc/php5/fpm/pool.d/www.conf',
    source  => 'puppet:///modules/php/www.conf',
    ensure  => 'present',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['php'],
  }

}
