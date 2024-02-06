#!/bin/bash

# Import config from container_config
source ./config/container_setup.config

if [ "$mount_from" = "" ]; then
    # Path to _host_ folder to mount file from
    mount_from=$(dirname "$(pwd)")
fi

# Path to _container_ folder to mount files onto
work_directory=/home/$name/"$(basename "$mount_from")"

# If not using Windows and .Xauthority doesn't exist, create an empty one (for running containers on WSL)
if grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null && [ ! -f "~/.Xauthority" ]; then
    touch -a ~/.Xauthority
fi

# Different username and group options for Docker and podman
# Extra mounting options for podman (to account for not being a privilaged user)
if [ "$container_manager" = "docker" ]; then
    container_specific_user_config="-e DOCKER_USER_NAME=$(id -un) \
                                    -e DOCKER_USER_ID=$(id -u) \
                                    -e DOCKER_USER_GROUP_NAME=$(id -gn) \
                                    -e DOCKER_USER_GROUP_ID=$(id -g)"
    container_specific_mouting=""
else
    container_specific_user_config="--userns=keep-id"
    container_specific_mouting="-v /dev/:/dev:rslave --mount type=devpts,destination=/dev/pts"
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
        $container_specific_user_config \
        $container_specific_mouting \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /home/$name/.Xauthority:/home/$name/.Xauthority \
        -v $mount_from:$work_directory \
        -e DISPLAY=:1.0 \
        -e XAUTHORITY=/home/$name/.Xauthority \
        -w "/home/$name" \
        "$container_name"
fi
