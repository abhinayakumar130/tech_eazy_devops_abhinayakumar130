#!/bin/bash

# Install dependencies
sudo apt update
sudo apt install unzip wget curl -y

# Install AWS CloudWatch Agent
sudo apt install amazon-cloudwatch-agent -y

# Create directory and log file
sudo mkdir -p /opt/tech_eazy_devops_abhinayakumar130/
sudo touch /opt/tech_eazy_devops_abhinayakumar130/app.log
sudo chown ubuntu:ubuntu /opt/tech_eazy_devops_abhinayakumar130/app.log

# Simulate error logs
echo "ERROR: Something went wrong in test instance!" >> /opt/tech_eazy_devops_abhinayakumar130/app.log

# Download CloudWatch config
sudo wget https://raw.githubusercontent.com/abhinayakumar130/tech_eazy_devops_abhinayakumar130/ass-5/terraform/cloudwatch-config.json -O /opt/cloudwatch-config.json

# Start the CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/cloudwatch-config.json -s

