#!/bin/bash

echo "Welcome to VAC PBX Gen 4 Installation"
echo "--------------------------------------"
echo "This Version is v5.1"
echo "--------------------------------------"
echo "You are in level one."
echo "--------------------------------------"

# Set timezone
echo "Setting timezone to Asia/Kolkata..."
timedatectl set-timezone Asia/Kolkata

# Update system packages
echo "Checking for updates..."
yum check-update

echo "Launching updates..."
yum update -y

# Install epel-release
echo "Installing epel-release..."
yum -y install epel-release

# Update again after installing epel-release
echo "Updating system again..."
yum update -y

# Disable SELinux
echo "Disabling SELinux..."
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Size
echo "Please Check the Hard disk Storage:"
df -h

echo "Please Check the Memory:"
free -h

# Reboot the system
echo "Rebooting the system. Hold on..."
reboot
