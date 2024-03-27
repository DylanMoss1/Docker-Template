#!/bin/bash

# Import config from container_config
source ./config/container_setup.config
source ./config/private_details/private.config

if [ "$add_SSH_keys" = "true" ]; then
  # If SSH keys are not provided in ./private_details, retrieve SSH keys from the host machine and place them in ./config/private_details 
  ./utils/retrieve_ssh_keys.sh
fi

# Build the container with the chosen container manager (either Docker or podman)
$container_manager build -t $container_name \
  --build-arg terminal_name="$terminal_name" \
  --build-arg name="$name" \
  --build-arg password="$password" \
  --build-arg user_id=$(id -u) \
  --build-arg group_id=$(id -g) \
  --build-arg add_SSH_keys="$add_SSH_keys" .

# If using the host's SSH keys, remove them from ./config/private_details 
if [ "$add_SSH_keys" = "true" ] && [ "$custom_keys_provided" = "false" ]; then
  echo -e "\n[WARNING]: Custom public and private SSH keys not provided. Defaulting to the host SSH keys.\n"
  rm "./config/private_details/container_id_rsa.pub"
  rm "./config/private_details/container_id_rsa"
fi
