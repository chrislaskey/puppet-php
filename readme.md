About
================================================================================

A custom puppet module for installing PHP 5.4 on Ubuntu server 12.04 using
a [custom PPA](https://launchpad.net/~ondrej/+archive/php5) by Ondřej Surý.

Also centralizes PEAR and PECL installation locations instead
of polluting the dir namespace.

In addition to installing and setting up PHP 5.4, it also installs
[xhrprof](https://github.com/facebook/xhprof) and
[phpunit](http://phpunit.de/).

Puppet dependencies
-------------------

This module depends on the following Puppet modules:

	dependency 'puppetlabs/apt', '>= 1.1.0'
	dependency 'puppetlabs/stdlib', '>= 2.2.1'

License
================================================================================

All code written by me is released under MIT license. See the attached
license.txt file for more information, including commentary on license choice.
