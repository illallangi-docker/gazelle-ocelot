#!/bin/sh
set -e

rsync -ah \
      --exclude '*.template' \
      --exclude '*.md' \
      --exclude '*.tar.gz' \
      --exclude 'docs' \
      --exclude '.gitattributes' \
      --exclude '.gitignore' \
      --exclude '*.sql' \
      --exclude 'sphinx.conf' \
      --update "${GAZELLE_SRC}/" "/opt/web/"

rsync -am \
      --include='*.sql' \
      --include='*/' \
      --exclude='*'  \
      "${GAZELLE_SRC}/" "/opt/sql/"

rm -rf /docker-entrypoint-initdb.d/
ln -s /opt/sql /docker-entrypoint-initdb.d

find /templates.d/ -type f -exec sh -c 'templater ${0} > ${0#/templates.d}' {} \;

if [ -e /usr/local/bin/docker-entrypoint.sh ]; then
  exec /usr/local/bin/docker-entrypoint.sh "$@"
else
  exec "$@"
fi
