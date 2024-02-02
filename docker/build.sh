#!/bin/bash 

source ./config/docker_config

$container_manager build -t $container_name \
  --build-arg terminal_name=$terminal_name \
  --build-arg name=$name \
  --build-arg password=$password \
  --build-arg user_id=$(id -u) \
  --build-arg group_id=$(id -g) .