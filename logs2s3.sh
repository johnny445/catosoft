#!/bin/bash/
mkdir /root/logs
mkdir /root/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")
sudo cp -r /var/lib/docker/containers/*/*.log.1 /root/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")
aws s3 cp --recursive /root/logs/ s3://getdockerlogs/


