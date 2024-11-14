#!/bin/sh

if [ "$#" -lt 3 ]; then
  echo "Invalid parameters."
  exit
fi

IP=$1
DNS=$2
SERVER=$3

nslookup_result=$(nslookup $DNS $SERVER | grep -A 1 "Name:" | grep "Address:" | awk '{print $2}')
echo $nslookup_result
OK="0"
for ns_ip in $nslookup_result; do
  if [ "$ns_ip" = "$IP" ]; then
    OK="1"
    break
  fi
done

if [ "$OK" = "0" ]; then
  echo "Bogus IP for $DNS!"
else
  echo "Correct ip for $DNS"
fi
