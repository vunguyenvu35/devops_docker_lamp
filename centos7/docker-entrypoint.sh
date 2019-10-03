#!/bin/bash
set -e

for var in "$@"
do

    if [ "$var" = 'crond' ]; then
        # start crond
        crond
    fi

    if [ "$var" = 'php-fpm' ]; then
        # start php-fpm
        /etc/init.d/php-fpm start
    fi

done

# echo system
tail -f /dev/null
