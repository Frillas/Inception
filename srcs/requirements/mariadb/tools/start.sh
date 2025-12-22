#!/bin/sh
set -e

exec mysqld --user=mysql --console &
wait $!
