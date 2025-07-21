#!/bin/bash

# Install dialog if not installed
if ! command -v dialog &> /dev/null; then
  echo "Installing dialog..."
  yum install -y dialog || apt install -y dialog
fi

# Step 1: Get License Key from user via dialog
LICENSE_KEY=$(dialog --inputbox "Enter your License Key" 8 40 --stdout)

if [[ -z "$LICENSE_KEY" ]]; then
  echo "License key cannot be empty."
  exit 1
fi

# Step 2: Get GitHub Token from PHP
TOKEN=$(curl -s "https://vaccrm.com/install.php?lic=$LICENSE_KEY")

if [[ -z "$TOKEN" ]]; then
  echo "Failed to retrieve token from license key"
  exit 1
fi

# Step 3: Clone the private repository using token
REPO_URL="https://$TOKEN@github.com/vac-soft/VACPBX_GEN4.git"
INSTALL_DIR="/opt/VACPBX_GEN4"

echo "Cloning repository..."
if [ -d "$INSTALL_DIR" ]; then
  echo "Removing old install directory..."
  rm -rf "$INSTALL_DIR"
fi

git clone "$REPO_URL" "$INSTALL_DIR"
if [ $? -ne 0 ]; then
  echo "Git clone failed. Invalid token or permission denied."
  exit 1
fi
# Step 4: Run install script
cd "$INSTALL_DIR" || exit 1
chmod +x *.sh

if [[ -f vacpbxinstall1.sh ]]; then
  echo "Running installation script..."
  ./vacpbxinstall1.sh
else
  echo "install1.sh not found in repository."
  exit 1
fi

