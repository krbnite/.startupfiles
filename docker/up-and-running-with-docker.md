# Up and Running with Docker:  Ensuring a Consistent Computational Environment 
* by Kevin Urban (2020-Mar-27)


You should learn a thing or two about Docker, but -- that said, I've made it
as easy as possible to maintain our team's Docker practices without much
friction.


# Good Stuff First: The Script!
This assumes you have Docker installed on your local computer or remote
EC2 instance already.  

In the top-level of your project, add a new text file -- call it 
`docker.sh` or something you find useful (e.g., `startproj.sh`
or `kevin-is-awesome.sh` -- whatever).  The add the following
script to it:


```
# Assumptions: 
# * You have a git config file @ ~/.gitconfig on your local dev machine.
# * You have AWS config files located @ ~/.aws on your local dev machine.
sudo docker run \
  -it \
  --rm \
  -p $1:$1 \
  -v "$PWD":/home/jovyan/"${PWD##*/}" \
  -v ~/.gitconfig:/home/jovyan/.gitconfig \
  -v ~/.aws:/home/jovyan/.aws \
  -e JUPYTER_ENABLE_LAB=yes \
  --user `id -u` --group-add users \
  jupyter/tensorflow-notebook:7a0c7325e470 \
  jupyter lab --no-browser --port=$1
```

To run this, just pick a port number.  

```
sh docker.sh 8883
```

On an EC2, this
should be the port number you used to create an SSH tunnel
to your local machine:

```
ssh -L localhost:8883:localhost:8883 <userName>@<ipAddress>
```

That's it!  The jupyterlab.sh script will launch a new Docker Container from
the `jupyter/tensorflow-notebook:7a0c7325e470` Docker Image and punt
you into a Jupyter Lab session, where you can create experimental
notebooks (note: as a rule, all notebooks should live in `<project>/notebooks`
and follow the naming convention outlined there).
If you've run this script from the top level of your project tree, your 
entire project repo will be seamlessly mounted inside the container.
In other words, though you are in a containerized environment, you are
literally working on your local dev machine's files.  

Assuming you
have followed the Git and AWS config file conventions on your local machine (e.g., having them
exist at `~/.gitconfig` and `~/.aws/`, respectively), then you'll be able to interact with Git and AWS as
you normally would, e.g., `git status`, `git add .`, or `aws s3 ls`, etc.
This is awesome: you will be working in a very useful Docker Image for
starting out project development -- and it will be the same exact environment,
no matter if you're on your own MacBook, a colleague's Linux machine, or an Ubuntu EC2
instance.


# The Breakdown
## Pre-Built Docker Image
First and foremost, we use a beautiful pre-built Docker image 
made by the Jupyter team: `jupyter/tensorflow-notebook`.  

* https://hub.docker.com/r/jupyter/tensorflow-notebook

To make using Jupyter notebooks consistent
across computers and platforms, there is Docker Image called `jupyter/base-notebook` built
on top of the Ubuntu Image.  On top of that, another image is built: 
`jupyter/minimal-notebook`.  From there, `jupyter/scipy-notebook` is built.  And
finally, atop that we have the one we use above:  `jupyter/tensorflow-notebook`. 

You will notice in the `docker run` command, the notebook is associated with
a hash ID: `jupyter/tensorflow-notebook:7a0c7325e470`.  This is to ensure
the same image is used every time.  If the hash is not specified, the `docker run`
command would default to whatever is the latest `jupyter/tensorflow-notebook` commit.

By using this pre-built computational environment, you can rest
assured most things you want to do are supported by default.  This
largely removes the need to build
your own complex Dockerfile!  But if you need to customize the environment,
it's easy to do:

```
FROM jupyter/tensorflow-notebook:7a0c7325e470
# OTHER Dockerfile commands
```

More Info:
* https://jupyter-docker-stacks.readthedocs.io/en/latest/

## Directory Mapping: Docker Environment, Host Machine Files
One thing you should know about Docker containers: they are
volatile!  In other words, anything you create inside a 
Docker container fails to exist once you shut down the Docker
container.

Fret not!  What you really want the Docker environment for is
to ensure a fully replicable environment on any machine.  It's not
necessarily for saving files.  Instead, you can map any 
directory from your host machine into the Docker container.  Then, anything
you create in that directory within the Docker container is preserved
on your host machine, even after you shut the Docker container down.


The script assumes you are in the top-level directory of your
project.  It then maps your entire project tree into the Docker
container using the `-v` flag, like so:  

```
-v "$PWD":/home/jovyan/"${PWD##*/}"
```

Here, `jovyan` is the default name of the user in the Jupyter
Docker image.


## Credential Mapping
Docker containers start fresh every time.  Anything you did inside
a Docker container the last time is gone, unless it was in a directory
mapped to your host machine.  So, same thing for most credentials
really.  You can create a new custom Docker image that has the
credentials you need inside, for sure.  But if you are using
a pre-built Jupyter Docker image like above, then you will
need to map your credentials.  

This is what we do for AWS and Git:

```
docker run \
  # ...some flags...
  -v ~/.gitconfig:/home/jovyan/.gitconfig \
  -v ~/.aws:/home/jovyan/.aws \
  # ...some more flags, etc...
```

## Permissions Mapping
One issue we had at first was not being able to use the
directories we had mapped inside.  The user `jovyan` (uid 1000) was
not allowed: the directories were owned (and group owned) by our EC2 user, `es-admin`,
which has uid 1002.

```
# Find your user ID
id -u

# Find your group ID
id -g
```

Turns out, we can "trick" the system into letting `jovyan` inside by
changing the uid from 1000 to the host user's ID (e.g., 1002 for es-admin
on one of our EC2 machines), as well as mapping the group IDs.

You can do it like so:
```
docker run \
  # ...some flags...
  --user `id -u` --group-add users \
  # ...some more flags and stuff...
```
