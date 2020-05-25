# apt install awscli

# #aws s3 cp --recursive /var/log s3://newonews/

# apt-get install cloud-utils

# ec2metadata --instance-id

# mkdir /home/ubuntu/logs

# mkdir /home/ubuntu/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")

# sudo cp -r /var/log/* /home/ubuntu/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")/

# sudo chmod +rx /home/ubuntu/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")/*

# aws s3 cp --recursive /home/ubuntu/logs/ s3://newonews/


#!/bin/bash/

mkdir /home/ubuntu/logs

sudo chown ubuntu /home/ubuntu/*

mkdir /home/ubuntu/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")

sudo chown ubuntu /home/ubuntu/logs/*

sudo chown ubuntu /var/lib/docker/containers/*

sudo cp -r /var/lib/docker/containers/*/*.log.1 /home/ubuntu/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")

sudo chmod +rx /home/ubuntu/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")/*
sudo chown ubuntu /home/ubuntu/logs/$(ec2metadata --instance-id)-$(date "+%d-%m-%y")/*

aws s3 cp --recursive /home/ubuntu/logs/ s3://getdockerlogs/

