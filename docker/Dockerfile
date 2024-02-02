# syntax=docker/dockerfile:1

# Install base 
FROM ubuntu:22.04


# --- BEGIN get execution arguments ---

ARG name
ARG password
ARG terminal_name

ARG user_id
ARG group_id

# --- END get execution arguments ---


# --- BEGIN install packages ---

# Update packages

RUN apt-get -y update
RUN apt-get -y upgrade

# Install apt packages

RUN apt -y install python3-pip

RUN apt-get -y install wget gpg apt-transport-https
RUN apt-get -y install sudo vim nano ranger
RUN apt-get -y install x11-xserver-utils trash-cli

# Install Python libraries 

COPY ./install/python_requirements.txt /python_requirements.txt
RUN python3 -m pip install -r /python_requirements.txt
RUN rm /python_requirements.txt

# --- END install packages 


# --- BEGIN add user --- 

RUN addgroup --gid $group_id $name
RUN adduser --disabled-password --uid $user_id --gid $group_id --gecos "" --shell /bin/bash $name
RUN echo "$name:$password" | chpasswd
RUN echo "Defaults:$name      !authenticate" >> /etc/sudoers
RUN echo "$name ALL=(ALL:ALL) ALL" >> /etc/sudoers

# --- END add user 


# --- BEGIN add aliases --- 

COPY ./aliases/global_aliases.txt /global_aliases.txt
COPY ./aliases/local_aliases.txt /local_aliases.txt 

RUN echo "$(cat /global_aliases.txt)" >> /home/$name/.bashrc
RUN echo "$(cat /local_aliases.txt)" >> /home/$name/.bashrc

RUN rm /global_aliases.txt /local_aliases.txt

RUN . /home/$name/.bashrc

# --- END add aliases --- 


# --- BEGIN local changes ---

# ********************************** #
#                                    #
#  INSERT LOCAL DOCKER CHANGES HERE  #
#                                    #
# ********************************** #

# --- END local changes ---


# --- BEGIN switch to user ---

RUN echo "export PS1='🐳 \e[1;32m$name@$terminal_name\e[1;0m:\e[1;34m\w\e[1;0m$ '" >> /home/$name/.bashrc
USER $name

# --- END switch to user ---