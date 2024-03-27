#!/bin/bash

# If SSH keys are not provided in ./private_details, retrieve SSH keys from the host machine

# If custom SSH key is provided
if [ -f ./config/private_details/container_id_rsa ] && [ -f ./config/private_details/container_id_rsa.pub ]; then
  custom_keys_provided="true"
else
  custom_keys_provided="false"
fi

# If custom SSH key is not provided,
if [ "$custom_keys_provided" = "false" ]; then
  # Check if using Windows
  if [ "$(uname -o 2>/dev/null)" = "Cygwin" ]; then
    cp "/c/Users/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa" 2>/dev/null
    cp "/c/Users/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub" 2>/dev/null
  # Check if using WSL
  elif grep -qEi "(Microsoft|WSL)" /proc/version &>/dev/null; then
    # Check if there is a WSL-specific key
    if [ -f /home/$host_name/.ssh/id_rsa ]; then
      cp "/home/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa" 2>/dev/null
      cp "/home/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub" 2>/dev/null
    # Otherwise default to the Windows key
    else
      cp "/mnt/c/Users/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa" 2>/dev/null
      cp "/mnt/c/Users/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub" 2>/dev/null
    fi
  # Otherwise, assume we are using Linux/MacOS
  else
    # Assume host machine is Linux or MacOS
    cp "/home/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa" 2>/dev/null
    cp "/home/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub" 2>/dev/null
  fi
fi

# If no SSH keys found on the host machine
if [ ! -f ./config/private_details/container_id_rsa ]; then
  echo -e "\n[ERROR]: No SSH keys found on host machine.\n"
  exit 1
fi
