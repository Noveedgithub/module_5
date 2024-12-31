#!/bin/bash

# Define the Terraform version to install
TERRAFORM_VERSION="1.5.7"

# Download the Terraform binary
curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o /tmp/terraform.zip

# Install unzip if not already installed
sudo apt-get install -y unzip

# Unzip and move Terraform binary to /usr/local/bin
sudo unzip -o /tmp/terraform.zip -d /usr/local/bin/

# Set executable permissions
sudo chmod +x /usr/local/bin/terraform

# Clean up
rm -f /tmp/terraform.zip

# Verify the installation
terraform --version
