#!/bin/sh

HOST=$(hostname)

cat /etc/hosts | while read line
do
  set -- $line
  IP=$1
  DNS=$2

  if [ -z "$IP" ]; then
    break
  fi

  if [ "$DNS" = "localhost" ] || [ "$DNS" = "$HOST" ]; then
    continue
  fi

  nslookup_result=$(nslookup $DNS 8.8.8.8 | grep -A 1 "Name:" | grep "Address:" | awk '{print $2}')

  OK="0"
  for ns_ip in $nslookup_result; do
    if [ "$ns_ip" = "$IP" ]; then
      OK="1"
      break
    fi
  done

  if [ "$OK" = "0" ]; then
    echo "Bogus IP for $DNS in /etc/hosts!"
  fi
done
