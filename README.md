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

### (Optional) Customise Dockerfile 

Replace `FROM ubuntu:22.04` with your preferred base image. 

Replace `INSERT LOCAL CONTAINER CHANGES HERE` block with any "local" Dockerfile commands specific to your project. 

### (Optional) Customise container environment 

Add Python dependencies to `./docker/config/dependencies/python_requirements.txt`. Leave blank if there are no dependencies. 

These take the form `<python_package>` for the most up-to-date package, or `<python_package>==<version>` for a pinned package version. Multiple dependencies are separated by newlines. For example: 

```
tensorflow==2.3.1
uvicorn==0.12.2
```

Add `~/.bashrc` aliases to `./docker/config/aliases/global_aliases.txt` or `./docker/config/aliases/local_alisaes.txt`. These are split into separate files to differentiate between "local" aliases specific to this project, or "global" aliases you want to reuse across multiple projects. 

These should take the form `alias <alias_name>=<alias_command>`. Multiple aliases are separated by newlines. For example: 

```
alias c="clear"
alias e="exit"
```

### Build and run project 

Build image from Dockerfile: 

`./docker/build.sh`

Spawn container from image, and log into container:

`./docker/run.sh`

Log into existing container: 

`./docker/run.sh` (from a new terminal). 

## Notes 

This repo has been primarily tested using podman on Ubuntu and WSL. Use Docker and other operating systems at your own risk.
