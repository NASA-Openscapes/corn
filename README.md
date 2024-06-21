# corn 🌽


Jupyterhub base image for the [NASA Openscapes Hub](https://nasa-openscapes.github.io/2021-Cloud-Hackathon/)

![](https://img.shields.io/docker/image-size/openscapes/python?sort=date)
<a href="https://hub.docker.com/repository/docker/openscapes/python/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/docker/v/openscapes/python"></a>

## Overview

### This project allows the provisioning of a multi-kernel Docker base image for Jupyterhub deployments.

In collaborative efforts -like this NASA hackathon- there are multiple teams working on different stacks and we often run into situations where `Team A` will need to use Python 3.8 with say `xarray v0.14` and `Team B` may need Python 3.9 and `xarray v0.17`.  A simple solution would be to reconcile these 2 environments so both teams can run their code. However, this is not always straight forward or even possible. Therefore having a multi kernel base image for Jupyterhub deployments makes a lot of sense. 

**`corn`** uses the amazing [Pangeo's base image](https://github.com/pangeo-data/pangeo-docker-images), installs all the environments it finds under `ci/environments` and makes them available as kernels in the base image so users can select which kernel to use depending on their needs. The only requirement to add kernels is to use a conda environment.yml file (pip dependencies can be included in environment.yml) and a name file.

* **environment.yml**: conda environment file
* **name.txt**: the name for the environment, it can be the same as the one used in the environment file


## Adding a new kernel

To add a new kernel we need to create a new folder under `ci/environments/` and add the 2 files described above. Say we want to run our amazing new notebook that uses pandas and python 3.10.

We will need a conda environment file `environment.yml` 
```yaml
name: amazing-env
channels:
  - conda-forge
dependencies:
  - python="3.10"
  - pandas>=1.3
  - pip
```
and our name.txt file
```
amazing-env
```

## **That's it!**

> Note: if you have pip installable dependencies, they must be listed using a `requirements.txt` file.

<!-- [![badge](https://img.shields.io/static/v1.svg?logo=Jupyter&label=Openscapes&message=AWS+us-west-2&color=orange)](https://openscapes.2i2c.cloud/hub/user-redirect/git-pull?repo=https%3A%2F%2Fgithub.com%2FNASA-Openscapes%2F2021-Cloud-Hackathon&urlpath=lab%2Ftree%2F2021-Cloud-Hackathon%2Ftutorials&branch=main) --> 

### Updating quarto

To update the [quarto](https://quarto.org) installation you'll need to change the version number in corn's [Dockerfile](https://github.com/NASA-Openscapes/corn/blob/main/ci/Dockerfile#L9). After committing changes, the GitHub Action will begin - see next.

## Updating the image in the JupyterHub

After we commit our changes to the `main` branch of this repo, the GitHub Action build will be triggered. Then, the Github Action will push the resulting Docker image to [dockerhub](https://hub.docker.com/r/openscapes/python/tags), creating an image tagged with the commit hash. This can take ~20 minutes.

You can try this newly created image by using the "Bring your own image" functionality in the 
JupyterHub. Specify the image with the name `openscapes/python:$TAG`, where `$TAG` is the tag of the Dockerhub image (which is the same as the commit hash). You can copy the name from the `docker pull` command shown in [Dockerhub](https://hub.docker.com/r/openscapes/python/tags).

Once you've verified it is working the way you want, we need to update the python image in our Jupyterhub configuration. The quickest way to do this is to create a pull request [here](https://github.com/2i2c-org/infrastructure/blob/main/config/clusters/openscapes/common.values.yaml#L68), updating `openscapes/python:$TAG`, with the tag/commit hash. For 2i2c deployments there is a GUI that allows administrators to do it.

Then, you'll go to <https://openscapes.2i2c.cloud/hub/home> > Stop My Server (or File > Log Out) to stop your server and restart it. Then the Docker image should be updated.

> Note: Looks like 2i2c caches the user image so tags like `main` won't be updated even if they have changes. Using the actual commit hash is a better practice for now.

## Testing changes to the image locally

If you want to test your changes locally (i.e., without building in GitHub actions and pushing to Dockerhub), you can do so on your own computer using Docker:

1. [Install Docker Desktop](https://docs.docker.com/desktop/)
2. Make sure Docker is running, then build the image with:

```
# make sure you are in the "ci" directory
cd ci
docker build -t openscapes/corn:test . --platform linux/amd64
```

The `--platform linux/amd64` flag is only necessary if you are _not_ on a
machine with an x86-64 chip architecture (e.g., an M1 or M2 Mac, which have an
ARM-based architecture).

Once the image has been built, you can run it with:

```
docker run -p 8888:8888 --platform linux/amd64 openscapes/corn:test jupyter lab --ip=0.0.0.0
```

If a browser doesn't automatically open, you can open one of the links that 
is generated in the output. It will look something like:

```
http://127.0.0.1:8888/lab?token=a74663dba15a5e5cab52ef4bd6a9346034fd1ab927f6a29b
```

Note that the home directory (`/home/jovyan`) will look different than you are
used to in the Hub. This is because in the local image the home directory still
contains artifacts from the image building process, while in the Hub a shared
AWS NFS drive is mounted to `home/jovyan`, giving you access to your persistent
home directory in the Hub.


## What's next?

This is a effective but probably inefficient way of building environments, exploring staged partial builds in Docker or using [conda-store](https://github.com/Quansight/conda-store) to build each environment and then pulling them into a Docker image may be more efficient.

The final size of the image depends on the dependencies for each environment, thus avoiding multiple Python versions is still recommended.

