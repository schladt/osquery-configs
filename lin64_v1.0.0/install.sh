#!/bin/bash

if [[ $1 == "" ]]; then
  echo
  echo USAGE: $0 [-u] osquery.tar.gz osquery.conf 
  echo -e "\t To install: ARG1 must be path to .tar.gz of osquery package. ARG2 must be path to config file"
  echo -e "\t To uninstall: ARG1 must be '-u'"
  echo
  exit
fi

# Run as root to install CEDAR
if [[ $EUID > 0 ]]; then 
	echo "Please run as root to install osquery"
  exit
fi

# remove osquery
echo "Removing previous versions of osquery..."

# remove service
systemctl disable osqueryd.service
systemctl stop osqueryd.service

# remove os query files
rm -rf /etc/init.d/osqueryd 
rm -rf /etc/osquery/
rm -rf /usr/share/osquery/
rm -rf /var/log/osquery/
rm -rf /usr/lib/osquery/
rm -rf /usr/bin/osqueryctl
rm -rf /usr/bin/osqueryd
rm -rf /usr/bin/osqueryi
echo "...osquery removal complete."

# Exit now if we are unstalling
if [[ $1 == -u ]]; then
    exit
fi

echo "Extracting osquery..."

mkdir /tmp/osquery
tar -xzvf $1 -C /tmp/osquery

echo "Installing osquery..."
cp -R /tmp/osquery/* /
cp $2 /etc/osquery/osquery.conf

systemctl enable osqueryd.service
systemctl start osqueryd.service

echo "Cleaning up..."
rm -rf /tmp/osquery

echo "Finished installing osquery."
