#!/bin/bash

# Note: The PEAR/PECL command is not a well formed POSIX command. The output
# to STDOUT can not be trusted. Since STDOUT is compromised, calls to print
# for status updates has been commented out. The exit code is still valid. 

PATH=$PATH:/bin:/usr/bin

which pecl 1> /dev/null
if [[ $? != "0" ]]; then
	print "Could not install XHProf. PECL not installed."
	exit 1
fi

php -m | grep xhprof
if [[ $? == "0" ]]; then
	print "XHProf already installed."
	exit 0
fi

PHP_MAJOR_VERSION=`php -r "echo PHP_VERSION;" | awk 'BEGIN {FS="."}{print $1}END { }'`
PHP_MINOR_VERSION=`php -r "echo PHP_VERSION;" | awk 'BEGIN {FS="."}{print $2}END { }'`

if [[ "$PHP_MAJOR_VERSION" -le 5 && "$PHP_MINOR_VERSION" -le 3 ]]; then 

	# If PHP < 5.4 then PECL can make && make install the straight forward way.
	pecl channel-discover pecl.php.net
	pecl install channel://pecl.php.net/xhprof-0.9.2

else
	
	# If PHP >= 5.4 and xhprof-0.9.2 then it needs to be patched after
	# download from the pecl.php.net repository and installed with PECL,
	# or downloaded directly from the github development repository and
	# built directly.
	cd /data/php/pear/temp/
	git clone git://github.com/facebook/xhprof.git xhprof-patched
	cd /data/php/pear/temp/xhprof-patched/extension/
	phpize && ./configure && make && make install

fi

# Add xhprof.so extension
test -f /etc/php5/conf.d/xhprof.ini || echo "extension=xhprof.so" > /etc/php5/conf.d/xhprof.ini

exit 0
