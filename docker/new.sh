#!/bin/bash 

# Add private SSH key to container  
if [ "$(uname -o 2>/dev/null)" = "Cygwin" ]; then
    # Assume host machine is Windows
    private_ssh_key_location="/c/Users/your_username/.ssh/id_rsa"
elif grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    # Assume host machine is WSL
    private_ssh_key_location="/mnt/c/Users/your_username/.ssh/id_rsa"
else
    # Assume host machine is Linux or MacOS
    private_ssh_key_location="~/.ssh/id_rsa"
fi

echo "$private_ssh_key_location"