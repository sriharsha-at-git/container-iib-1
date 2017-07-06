# container-iib
IBM® Integration Bus v10.x  containerized docker image

# Overview

This repository contains Dockerfile(s) and scripts to setup & run IIB container(s).

### Step-1: Clone this repository

git clone https://github.com/sriharsha-inthubss/container-iib.git
		
### Step-2: Create image(s) & Run application using setup script.
Navigate to version sub-directory 

cd container-iib/

set execution permission on script file if required & run

setup.bat

### Step-3: Check the iib runtime logs that are written to /var/logs/ by standard docker cli

docker logs iibserver_app_1
docker logs <container_id>

### Detailed description:-

The repo is into 3 directories, 1 each for creating image & finally running the app on container.

##### ubuntu_base dir is a simple base verion of ubuntu 14.04 image with kernal settings chnaged to meet IIB server requirements.

##### ubuntu_iib10 dir is an extension of "ubuntu:base" image(from above) with iib software downloaded & installed

Note:-  This can && will be used as a base image for any application/service specific containerazition.

##### ubuntu_iib10_app-1 is a runnable container with app(s) dpeloyed & security setup.

If required, for further application to be containered, we could resuse "ubuntu_iib10_app-<n>" directory pattern with target bar files.

