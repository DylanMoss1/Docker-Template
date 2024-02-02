#!/bin/bash

# Import config from container_config
source ./config/container_config

# If using podman: add extra id and mounting rules (to account for not being a privilaged user)
if [ "$container_manager" = "podman" ]; then
    podman_extra_args="--userns=keep-id \
                       -v /dev/:/dev:rslave --mount type=devpts,destination=/dev/pts"
else
    podman_extra_args=""
fi

# If container already running, execute into it - else spin up new container
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
        $podman_extra_args \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/$name/.Xauthority:/home/$name/.Xauthority \
        -v $mount_onto:$work_directory \
        -e DISPLAY=:1.0 \
        -e XAUTHORITY=/home/$name/.Xauthority \
        -e DOCKER_USER_NAME=$(id -un) \
        -e DOCKER_USER_ID=$(id -u) \
        -e DOCKER_USER_GROUP_NAME=$(id -gn) \
        -e DOCKER_USER_GROUP_ID=$(id -g) \
        -w "/home/$name" \
        "$container_name"
fi