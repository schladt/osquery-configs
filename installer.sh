#!/bin/bash

if [[ $EUID > 0 ]]; then 
	echo "Please run as root to install OSQUERY"
  exit
fi

echo "Extracting osquery..."
mkdir osquery
tar -xzvf osquery.tar.gz -C ./osquery

echo "Installing osquery..."
cp -R osquery/* /
cp osquery.conf /etc/osquery/osquery.conf
systemctl enable osqueryd.service
systemctl start osqueryd.service

echo "Cleaning up..."
rm -rf osquery

echo "Finished installing osquery. (restart to ensure event framwork is running)"