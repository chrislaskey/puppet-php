#!/bin/bash

# Note: The PEAR/PECL command is not a well formed POSIX command. The output
# to STDOUT can not be trusted. Since STDOUT is compromised, calls to print
# for status updates has been commented out. The exit code is still valid.

PATH=$PATH:/bin:/usr/bin/

which phpunit
if [[ $? == "0" ]]; then
	exit 0
fi

which pear
if [[ $? != "0" ]]; then
	print "Could not install PHPUnit. Pear not installed."
	exit 1
fi

pear channel-update pear.php.net
pear upgrade pear 

pear config-set auto_discover 1 
pear install --alldeps pear.phpunit.de/PHPUnit

exit 0
