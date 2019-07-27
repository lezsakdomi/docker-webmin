#!/bin/sh
# Runs services on runlevel 3

for f in /etc/rc3.d/*; do
  echo "\033[32mStarting \033[0;32;1m`basename $(readlink "$f")`\033[0;32m...\033[0m"
  "$f" start
done

echo "\033[1mStartup sequence finished. Now tailing some logs...\033[0m"
tail -f \
  /var/log/apache2/error.log \
  /var/log/mysql/error.log \
  /var/log/proftpd/proftpd.log \
  /var/webmin/miniserv.error

sleep infinity
