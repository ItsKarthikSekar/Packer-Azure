#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

# install application or agents
sudo apt-get update -y
sudo apt-get install -y nginx
sudo systemctl disable nginx

sudo /usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync