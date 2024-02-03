# syntax=docker/dockerfile:1

# Install base 
FROM ubuntu:22.04


# --- BEGIN get execution arguments ---

# Username and password within the container 
ARG name
ARG password

# Name of the terminal, purely cosmetic (i.e. terminal looks like name@terminal-name:/)
ARG terminal_name

# Id and group of host user
ARG user_id
ARG group_id

# Host's private SSH key
ARG private_ssh_key

# --- END get execution arguments ---


# --- BEGIN install packages ---

# Update packages

RUN apt-get -y update
RUN apt-get -y upgrade

# Install useful apt packages

RUN apt -y install python3-pip

RUN apt-get -y install wget gpg apt-transport-https
RUN apt-get -y install sudo vim nano ranger git 
RUN apt-get -y install x11-xserver-utils trash-cli

# Install Python libraries (add dependencies in ./config/dependencies/python_requirements.txt)

COPY ./config/dependencies/python_requirements.txt /python_requirements.txt
RUN python3 -m pip install -r /python_requirements.txt
RUN rm /python_requirements.txt

# --- END install packages 


# --- BEGIN add user --- 

# Adds user to the container, with the same id and group as the host user (so they can access all mounted files)
RUN addgroup --gid $group_id $name
RUN adduser --disabled-password --uid $user_id --gid $group_id --gecos "" --shell /bin/bash $name
RUN echo "$name:$password" | chpasswd
RUN echo "Defaults:$name      !authenticate" >> /etc/sudoers
RUN echo "$name ALL=(ALL:ALL) ALL" >> /etc/sudoers

# Add private ssh key from host to container 
RUN mkdir /home/$name/.ssh
RUN echo "$private_ssh_key" >> "/home/$name/.ssh/id_rsa"
RUN chmod 700 "/home/$name/.ssh/"
RUN chmod 600 "/home/$name/.ssh/id_rsa"
RUN chown -R dylan:dylan "/home/$name/.ssh/"
RUN ssh-keyscan -H github.com >> "/home/$name/.ssh/known_hosts"

# --- END add user 


# --- BEGIN git profile ---

# Add git username and email
RUN git config --global user.name "${github_username}"
RUN git config --global user.email "${github_email}"

# --- END git profile ---


# --- BEGIN add aliases --- 

# Edit aliases in ./config/aliases

# Global aliases are those used across all your containerised projects
# Local aliases are those useful to just this specific project
# Seperates out re-usable aliases for future projects

# Add alias files to the container
COPY ./config/aliases/global_aliases.txt /global_aliases.txt
COPY ./config/aliases/local_aliases.txt /local_aliases.txt 

# Echo their contents into ~/.bashrc 
RUN echo "$(cat /global_aliases.txt)" >> /home/$name/.bashrc
RUN echo "$(cat /local_aliases.txt)" >> /home/$name/.bashrc

# Remove the alias files 
RUN rm /global_aliases.txt /local_aliases.txt

# Source ~/.bashrc 
RUN . /home/$name/.bashrc

# --- END add aliases --- 


# --- BEGIN local changes ---

# ************************************* #
#                                       #
#  INSERT LOCAL CONTAINER CHANGES HERE  #
#                                       #
# ************************************* #

# --- END local changes ---


# --- BEGIN add custom terminal text ---

# Create and colour custom terminal text (🐳 name@terminal-name:~/)
RUN echo "export PS1='🐳 \e[1;32m$name@$terminal_name\e[1;0m:\e[1;34m\w\e[1;0m$ '" >> /home/$name/.bashrc

# --- END add custom terminal text ---