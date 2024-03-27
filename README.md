# Docker Template 

Pre-build template for Docker / podman containers. Supports file mounting and SSH keys.

## Instructions 

### Install either Docker or podman 

Podman is strongly recommended for file permission syncing purposes. 

On Linux/WSL: 

`sudo apt-get update && sudo apt-get -y install podman`

On Windows:

Install from https://podman.io/

### Fill in details 

Fill out private details in: 

`./docker/config/private_details/private.config` 

Fill out general container setup details in: 

`./docker/config/container_setup.config`

Make sure to read the IMPORTANT notice. 

### Customise your container 

Customise the Dockerfile (`./docker/Dockerfile`)

- Replace `FROM ubuntu:22.04` with your preferred base image. 

- Replace `INSERT LOCAL CONTAINER CHANGES HERE` block with any "local" Dockerfile commands specific to your project. 

Add Python dependencies (`./docker/config/dependencies/python_requirements.txt`)

- Leave blank if there are no Python dependencies 

- Add dependencies in the form `<python_package>` or `<python_package>==<version>`, as with a standard Python requirements.txt file. For example: 

  ```
  tensorflow==2.3.1
  uvicorn==0.12.2
  ```

Add bashrc aliases (`./docker/config/aliases/global_aliases.txt` or `./docker/config/aliases/local_alisaes.txt`)

- Local and global aliases are separated purely for personal management reasons

- "local" aliases are specific to this project, and "global" aliases are those you wish to reuse across multiple projects. 

- Add aliases in the form `alias <alias_name>=<alias_command>` to either file (the effect is identical). For example: 

  ```
  alias c="clear"
  alias e="exit"
  ```

### Build and run project 

First move into the docker directory:

`cd ./docker`

Build image from Dockerfile: 

`./build.sh`

Spawn container from image, and log into container:

`./run.sh`

Log into existing container: 

`./run.sh` (from a new terminal). 

## Notes 

This repo has been primarily tested using podman on Ubuntu and WSL. Use with Docker and other operating systems at your own risk.
