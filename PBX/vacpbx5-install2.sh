#!/bin/bash

# Install dialog if not installed
if ! command -v dialog &> /dev/null; then
  echo "Installing dialog..."
  yum install -y dialog
fi

# Step 1: Get License Key from user via dialog
LICENSE_KEY=$(dialog --inputbox "Enter your License Key" 8 40 --stdout)

if [[ -z "$LICENSE_KEY" ]]; then
  echo "License key cannot be empty."
  exit 1
fi

# Step 2: Get GitHub Token from server (do not echo token)
TOKEN_RESPONSE=$(curl -s "https://vacsoftteck.com/license_system/install.php?lic=$LICENSE_KEY")

# Step 3: Check if response is valid token format (e.g., GitHub tokens usually start with "ghp_" or are 40-char hex)
if [[ "$TOKEN_RESPONSE" == *"EXPIRED"* ]]; then
  echo "License key expired. Please contact VAC Team."
  exit 1
elif [[ "$TOKEN_RESPONSE" == *"USED"* ]]; then
  echo "License key already used. Please contact VAC Team."
  exit 1
elif [[ "$TOKEN_RESPONSE" == *"INVALID"* ]]; then
  echo "License key is not valid. Please contact VAC Team."
  exit 1
elif [[ ${#TOKEN_RESPONSE} -lt 20 ]]; then
  echo "Invalid license key or token retrieval failed. Please contact VAC Team."
  exit 1
fi

# Step 4: Clone the private repository using token silently
REPO_URL="https://${TOKEN_RESPONSE}@github.com/vac-soft/VACPBX_GEN4.git"
INSTALL_DIR="/opt/VACPBX_GEN4"

echo "Cloning repository..."
yum install -y git

if [ -d "$INSTALL_DIR" ]; then
  echo "Removing old install directory..."
  rm -rf "$INSTALL_DIR"
fi

# Suppress token display by redirecting all output except errors
GIT_TERMINAL_PROMPT=0 git clone "$REPO_URL" "$INSTALL_DIR" 2> /tmp/git_error.log

if [ $? -ne 0 ]; then
  echo "❌ Git clone failed. Please verify license validity. Check /tmp/git_error.log for more."
  exit 1
fi

# Step 5: Run install script
cd "$INSTALL_DIR" || exit 1
chmod +x *.sh

if [[ -f vacpbxinstall2.sh ]]; then
  echo "✅ Running installation script..."
  ./vacpbxinstall2.sh
else
  echo "❌ install2.sh not found in repository."
  exit 1
fi
