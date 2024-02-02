#!/bin/bash 

# Add private SSH key to container  
# Path to _host_ folder to mount file from 
mount_onto=$(dirname "$(pwd)")

# Path to _container_ folder to mount files onto 
work_directory=/home/$name/"$(basename "$mount_onto")"

# Add private SSH key to container  
if [ "$(uname -o 2>/dev/null)" = "Cygwin" ]; then
    # Assume host machine is Windows
    private_ssh_key="$(cat /c/Users/$host_name/.ssh/id_rsa)"
elif grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    # Assume host machine is WSL
    private_ssh_key="$(cat /mnt/c/Users/$host_name/.ssh/id_rsa)"
else
    # Assume host machine is Linux or MacOS
    private_ssh_key="$(cat ~/.ssh/id_rsa)"
fi

echo $private_ssh_key