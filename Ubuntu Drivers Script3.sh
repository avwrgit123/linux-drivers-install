#!/bin/bash
echo "Ubuntu Drivers Script"
echo "Ubuntu Driver Installation and Update Script"
echo "Device Driver Installation Script"

# Update package list and install recommended drivers
sudo apt-get update -y && sudo apt-get upgrade -y && sudo ubuntu-drivers autoinstall

# Clean up old package files
sudo apt-get clean

echo "Driver installation completed."

