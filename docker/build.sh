#!/bin/bash 

# Import config from container_config
source ./config/container_config

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
        cp "/c/Users/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa"
        cp "/c/Users/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub"
    # Check if using WSL
    elif grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
        # Check if there is a WSL-specific key 
        if [ -f /mnt/c/Users/$host_name/.ssh/id_rsa ]; then
            cp "/mnt/c/Users/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa"
            cp "/mnt/c/Users/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub"
        # Otherwise default to the Windows key 
        else
            cp "/c/Users/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa"
            cp "/c/Users/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub"
        fi
    # Otherwise, assume we are using Linux/MacOS
    else
        # Assume host machine is Linux or MacOS
        cp "/home/$host_name/.ssh/id_rsa" "./config/private_details/container_id_rsa"
        cp "/home/$host_name/.ssh/id_rsa.pub" "./config/private_details/container_id_rsa.pub"
    fi
fi

# Run container manager (either Docker or podman) with config args 
$container_manager build -t $container_name \
  --build-arg terminal_name="$terminal_name" \
  --build-arg name="$name" \
  --build-arg password="$password" \
  --build-arg user_id=$(id -u) \
  --build-arg group_id=$(id -g) . \

if [ "$custom_keys_provided" = "false" ]; then
  echo -e "\n[WARNING]: Custom SSH keys not provided. Defaulting to the host SSH keys.\n"
  rm "./config/private_details/container_id_rsa.pub"
  rm "./config/private_details/container_id_rsa"
fi