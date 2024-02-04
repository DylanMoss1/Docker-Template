# Docker Template 

Pre-built template for Docker / podman containers. Features include: automatic mounting on the host file system, support for SSH keys, easy-to-use `build.sh` and `run.sh` scripts. 

It is **highly** recommended to use podman (due to safer permissions when mounting on the host's file system). 

This repo has been primarily tested using podman on Ubuntu and WSL. Use Docker and other OSes at your own risk.

# Install Podman 

On Linux/WSL: 

`sudo apt-get update && sudo apt-get -y install podman`

On Windows:

Install from https://podman.io/
