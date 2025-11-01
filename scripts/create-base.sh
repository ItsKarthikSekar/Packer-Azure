#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update -y
sudo apt-get upgrade -y

# baseline tools & agents
sudo apt-get install -y curl wget

sudo /usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync