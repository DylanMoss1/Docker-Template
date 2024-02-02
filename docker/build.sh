#!/bin/bash 

# Import config from container_config
source ./config/container_config

# Run container manager (either Docker or podman) with config args 
$container_manager build -t $container_name \
  --build-arg terminal_name="$terminal_name" \
  --build-arg name="$name" \
  --build-arg password="$password" \
  --build-arg user_id=$(id -u) \
  --build-arg group_id=$(id -g) . \
  --build-arg private_ssh_key="$private_ssh_key"