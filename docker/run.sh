#!/bin/bash

# Import config from container_config
source ./config/container_setup.config

# If left blank, defaults to "project_name/" (parent of "docker/")
if [ "$mount_from" = "" ]; then
  mount_from=$(dirname "$(pwd)")
fi

# Path to *container* folder to mount files onto
work_directory=/home/$name/"$(basename "$mount_from")"

# Different username, group, and mounting options for Docker and podman
if [ "$container_manager" = "docker" ]; then
  container_specific_user_config="-e DOCKER_USER_NAME=$(id -un) \
                                    -e DOCKER_USER_ID=$(id -u) \
                                    -e DOCKER_USER_GROUP_NAME=$(id -gn) \
                                    -e DOCKER_USER_GROUP_ID=$(id -g)"
  container_specific_mouting=""
elif [ "$container_manager" = "podman" ]; then
  container_specific_user_config="--userns=keep-id"
  container_specific_mouting="-v /dev/:/dev:rslave --mount type=devpts,destination=/dev/pts"
else
  echo "$container_manager is not a valid container_manager. Please select either 'docker' or 'podman'"
  exit 1
fi

# If container already running then execute into it, else spin up new container
if [ "$($container_manager container inspect -f '{{.State.Running}}' $container_name 2>/dev/null)" = "true" ]; then
  echo $'\nLogging into existing container...\n'
  $container_manager exec -it $container_name /bin/bash && exit 0
else
  echo $'\nSpawning new containing...\n'
  $container_manager run --rm -it \
    --name="$container_name" \
    --net=host \
    --ipc=host \
    --device=/dev/dri:/dev/dri \
    --user "$(id -u):$(id -g)" \
    $custom_args \
    $container_specific_user_config \
    $container_specific_mouting \
    -v $mount_from:$work_directory \
    -e DISPLAY=:1.0 \
    -w "/home/$name" \
    "$container_name"
fi
