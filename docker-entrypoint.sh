#!/bin/sh
set -e

cd /usr/local/src/ocelot-1.0
./configure
make
cp /usr/local/src/ocelot-1.0/ocelot /usr/local/bin/ocelot
cd

echo Waiting 60 seconds for ${MYSQL_HOST}:${MYSQL_PORT} to become available

#wait-for ${MYSQL_HOST}:${MYSQL_PORT} -t 60

exec "$@"
