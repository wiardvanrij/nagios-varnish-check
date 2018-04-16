#!/bin/bash
#
# check_varnish_health
#
# A nagios plugin to check the health status of a varnish web cache using varnishadm.
# Original version by rudi kramer - BSD-style copyright and disclaimer
#
# Changes:
# Uses varnishadm backend.list rather than debug.health which does not exists anymore.
# For the ease of use removed host + port. Using varnishadm by default is sufficient.
#
# Wiard van rij - sysrant.com

E_SUCCESS="0"
E_WARNING="1"
E_CRITICAL="2"
E_UNKNOWN="3"

PROGNAME=`basename $0`
CHECK_VARNISHD=`ps ax| grep varnishd| grep -v grep`

if [ -z "$CHECK_VARNISHD" ]; then
    echo "CRITICAL: varnishd is not running, unable to check health status"
    exit $E_CRITICAL
fi

COMMAND=`varnishadm backend.list 2>&1 | tail -n 1 | awk '{ print $3 }'`
OUTPUT=`varnishadm backend.list 2>&1 | tail -n 1`

if [ "$COMMAND" = "Healthy" ]; then
    echo "OK: $OUTPUT"
    exit ${E_SUCCESS}

else
    echo "CRITICAL: $OUTPUT"
    exit ${E_CRITICAL}
fi
