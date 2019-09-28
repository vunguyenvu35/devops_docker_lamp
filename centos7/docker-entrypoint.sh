#!/bin/bash
set -e

if [ "$1" = 'start' ]; then
    # start crond
    crond

    # start php-fpm
    /etc/init.d/php-fpm start

    # start httpd
    /usr/local/apache2/bin/httpd -D FOREGROUND

    # run
    tail -f /dev/null
fi

exec "$@"


