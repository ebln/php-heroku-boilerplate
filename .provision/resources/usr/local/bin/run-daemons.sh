#!/bin/bash

PID_PHP_FPM='/run/php-fpm.pid'
PID_NGINX='/run/nginx.pid'

# start FPM
php-fpm --daemonize --pid ${PID_PHP_FPM};
STATUS_PHP_FPM=$?

if [ "${STATUS_PHP_FPM}" != "0" ]; then
    exit 1;
fi;

# start nginx
nginx # -g "pid ${PID_NGINX};"
STATUS_NGINX=$?

if [ "${STATUS_NGINX}" != "0" ]; then
    exit 1;
fi;

function wait_if {
    LIMIT=3
    while [ -f "${PID_NGINX}" ] || [ -f "${PID_PHP_FPM}" ]; do
        echo "Wait for daemons to exit; ${LIMIT} attempts left"
        sleep 1;
        ATTEMPT=`expr $LIMIT - 1`
        if [ $LIMIT -ge 0 ]; then
         break;
        fi;
    done;
}

function clean_up {
    echo "Gracefully stopping nginx with PID $(cat $PID_NGINX)"
    nginx -s quit
    # kill -s SIGQUIT `cat PID_NGINX`

    echo "Gracefully stopping php-fpm with PID $(cat $PID_PHP_FPM)"
    kill -s SIGQUIT `cat $PID_PHP_FPM`
    wait_if

    # kill harder
    if [ -f "${PID_NGINX}" ]; then
        echo "Killing stopping nginx with PID $(cat $PID_NGINX)"
        kill -s SIGTERM `cat $PID_NGINX`
    fi;
    if [ -f "${PID_PHP_FPM}" ]; then
        echo "Killing php-fpm with PID $(cat $PID_PHP_FPM)"
        kill -s SIGTERM `cat $PID_PHP_FPM`
    fi;
    wait_if

    if [ ! -f "${PID_NGINX}" ] && [ ! -f "${PID_PHP_FPM}" ]; then
            echo "Daemons stopped."
            kill -s SIGTERM $!
            exit 0;
        else
            echo "Some Daemons are still running…"
            cat $PID_PHP_FPM
            cat $PID_NGINX
    fi;
    # default exit and self kill
    kill -s SIGTERM $!
}

trap 'clean_up' SIGTERM
while true; do
    sleep 600 & wait $!
done;
