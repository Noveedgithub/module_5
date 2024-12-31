#!/bin/bash

# Update the package index
sudo apt-get update -y

# Install prerequisites
sudo apt-get install -y \
    software-properties-common \
    python3-pip \
    python3-apt

# Add the Ansible PPA and install Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install -y ansible

# Verify the installation
ansible --version
