class php {

	# Packages
	# ==========================================================================

	package { "php":
		name => [
			"php5-cli",
			"php5-fpm",
			"php5-dev",
		],
		ensure => "latest",
		require => [
			Apt::Ppa["ppa:ondrej/php5"],
  	  	  	Exec['apt-get update'],
		],
	}

	package { "php-library":
		name => [
			"php-apc",
			"php5-curl",
			"php5-gd",
			"php5-imagick",
			"php5-mcrypt",
			"php5-mysql",
			"php-pear",
			"php5-xdebug",
		],
		ensure => "installed",
		require => [
			Package["php"],
		],
	}

	if ! defined( Package["sqlite"] ){
		package { "sqlite":
			ensure => "present",
		}
	}

	# Service
	# ==========================================================================

	service { "php":
		name => "php5-fpm",
		ensure => "running",
		enable => "true",
		pattern => "php-fpm",
		subscribe => [
			Package["php"],
			File["php.ini"],
			File["php-fpm.conf"],
			File["www.conf"],
		],
	}

	# Files
	# ==========================================================================
	# Note: the "files" dir is ommitted when using puppet:///.

	if ! defined(File["/etc/apt/sources.list.d/"]) {
		file { "/etc/apt/sources.list.d/":
			ensure => "directory",
			owner => "root",
			group => "root",
			mode => "0755",
		}
	}

	file { "php.ini":
		path => "/etc/php5/fpm/php.ini",
		source => "puppet:///modules/php/php.ini",
		ensure => "present",
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			Package["php"],
		],
	}

	file { "cli-php.ini":
		path => "/etc/php5/cli/php.ini",
		source => "puppet:///modules/php/php.ini",
		ensure => "present",
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			File["php.ini"],
			Package["php"],
		],
	}

	file { "php-fpm.conf":
		path => "/etc/php5/fpm/php-fpm.conf",
		source => "puppet:///modules/php/php-fpm.conf",
		ensure => "present",
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			Package["php"],
		],
	}

	file { "www.conf":
		path => "/etc/php5/fpm/pool.d/www.conf",
		source => "puppet:///modules/php/www.conf",
		ensure => "present",
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			Package["php"],
		],
	}

	file { "xhprof.ini":
		path => "/etc/php5/conf.d/xhprof.ini",
		source => "puppet:///modules/php/xhprof.ini",
		ensure => "present",
		owner => "root",
		group => "root",
		mode => "0644",
		require => [
			Package["php"],
			Exec["install-xhprof.sh"],
		],
	}

	file { "install-xhprof.sh":
		path => "/data/puppet/install-xhprof.sh",
		source => "puppet:///modules/php/install-xhprof.sh",
		ensure => "present",
		owner => "root",
		group => "root",
		mode => "0700",
		require => [
			Package["php"],
		],
	}

	file { "install-phpunit.sh":
		path => "/data/puppet/install-phpunit.sh",
		source => "puppet:///modules/php/install-phpunit.sh",
		ensure => "present",
		owner => "root",
		group => "root",
		mode => "0700",
		require => [
			Package["php"],
		],
	}

	# Execs
	# ==========================================================================
	# Note: scripts using PEAR/PECL should not have their output logged. The
	# PEAR/PECL command is not POSIX compliant and throws out misleading output.
	# The exit number is valid, so success/error can still be tracked.

	apt::ppa { "ppa:ondrej/php5":
		require => [
			File["/etc/apt/sources.list.d/"]
		],
	}

	exec { "install-xhprof.sh":
		command => "install-xhprof.sh",
		path => "/data/puppet/",
		user => "root",
		group => "root",
		refreshonly => "true",
		logoutput => "on_failure",
		require => [
			File["install-xhprof.sh"],
		],
		subscribe => [
			Package["php-library"],
		],
	}

	exec { "install-phpunit.sh":
		command => "install-phpunit.sh",
		path => "/data/puppet/",
		user => "root",
		group => "root",
		refreshonly => "true",
		logoutput => "on_failure",
		require => [
			File["install-phpunit.sh"],
		],
		subscribe => [
			Package["php-library"],
		],
	}

}
