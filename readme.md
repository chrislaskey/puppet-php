About
================================================================================

A custom puppet module for installing PHP FPM and CLI on Debian/Ubuntu systems.

If Ubuntu, installs the latest PHP version from a
[custom PPA](https://launchpad.net/~ondrej/+archive/php5) by Ondřej Surý.

PHP Modules
-----------

The following PHP modules are installed using apt packages:

	php5-cli
	php5-fpm
	php5-dev
	php-apc
	php-pear
	php5-curl
	php5-gd
	php5-imagick
	php5-mcrypt
	php5-memcached
	php5-mysql
	php5-pgsql
	php5-sqlite
	php5-xdebug
	phpunit

Puppet dependencies
-------------------

This module depends on the following Puppet modules:

	dependency 'puppetlabs/apt', '>= 1.1.0'
	dependency 'puppetlabs/stdlib', '>= 2.2.1'

License
================================================================================

All code written by me is released under MIT license. See the attached
license.txt file for more information, including commentary on license choice.
