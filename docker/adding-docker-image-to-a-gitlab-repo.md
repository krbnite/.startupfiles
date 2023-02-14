# Adding a Docker Image to a GitLab Repo
* by Roozbeh Atri (2020-Mar-27)


## Docker
Docker is containerization of a virtual machine without the over head of it. Docker makes it possible for codes to run on different environment by standardization the environment and adding the required libraries. 
This document is a guide on building a dockerfile and sharing it ion gitlab repo.

On gitlap each repo has a registery, and <b>registery for containers</b> is repo where you can push and pull docker containers.

### Setup on Terminal:
1. Make sure docker is installed:
``` 
$ which docker

/usr/local/bin/docker
```

if docker is not installed, please install it using the follwoing commands:

1. Update the apt package index:
```
$ sudo apt-get update
```
2. Install packages to allow apt to use a repository over HTTPS:
```
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
```
3. Add Docker’s official GPG key:
```
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
4. Verify that you now have the key with the fingerprint `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`, by searching for the last 8 characters of the fingerprint.
```
$ sudo apt-key fingerprint 0EBFCD88
    
pub   rsa4096 2017-02-22 [SCEA]
      9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
uid           [ unknown] Docker Release (CE deb) <docker@docker.com>
sub   rsa4096 2017-02-22 [S]
```
5. Use the following command to set up the stable repository. To add the nightly or test repository, add the word nightly or test (or both) after the word stable in the commands below. Learn about nightly and test channels.
```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```
#### INSTALL DOCKER ENGINE - COMMUNITY
1. Update the apt package index.
```
$ sudo apt-get update
```
2. Install the latest version of Docker Engine - Community and containerd, or go to the next step to install a specific version:
```
$ sudo apt-get install docker-ce docker-ce-cli containerd.io
```
3. Verify that Docker Engine - Community is installed correctly by running the hello-world image.
```
$ sudo docker run hello-world
```
This command downloads a test image and runs it in a container. When the container runs, it prints an informational message and exits.


Now that we have docker setup up properly we need to make a dockerfile with the installations for required tools in the environments. The rest of this file will explain how to create the docker file and add required libraries. After dockerfile is made, the document will guide through how to build and push the image repository. 

1. cd to the project path `cd roozbeh500/apnea-ecg`
2. make dockerfile `mkdir docker`; `touch docker/Dockerfile`
3. Add installation for the libararies and build the image: `docker build .`
Dockerfile is the way you define what is in your image.  it will contain the following parts:
* <b>FROM:</b> will start with a base image coming from dockerhub 
* <b>RUN:</b> installs packages
* <b>COPY:</b> copies the project into the image
* <b>CMD:</b>  provides defaults for an executing container.

4. make a file named `docker.sh` and add following code in it:
make sure to use the DOCK_IMAGE_ID from the image that was built in previous step
```
# Assumptions: 
# * You have a git config file @ ~/.gitconfig on your local dev machine.
# * You have AWS config files located @ ~/.aws on your local dev machine.
sudo docker run \
  -it \
  --rm \
  -p $1:$1 \
  -v "$PWD":/home/jovyan/"${PWD##*/}":z \
  -v ~/.gitconfig:/home/jovyan/.gitconfig \
  -v ~/.aws:/home/jovyan/.aws \
  -e JUPYTER_ENABLE_LAB=yes \
  --user `id -u` --group-add users \
  DOCKER_IMAGE_ID \
  jupyter lab --no-browser --port=$1


#  -e GRANT_SUDO=yes \

```

5. to use the docker image run: `sh docker.sh XXXX` (XXXX should be the port you will be using)


 ----------- 

## Login to GitLab docker registory
1. Login
```
sudo docker login registry.gitlab.com
```
for some reason docker login saves the credentials in an unencrypted way!

2. build an image:
```
sudo docker build -t registry.gitlab.com/roozbeh.atri/apnea-ecg .
```
3. Push the image:
```
sudo docker push registry.gitlab.com/roozbeh.atri/apnea-ecg
```
