# corn 🌽

Jupyterhub base image for the [NASA Cloud Hackweek 2021](https://nasa-openscapes.github.io/2021-Cloud-Hackathon/)

![](https://img.shields.io/docker/image-size/openscapes/corn?sort=date)
<a href="https://hub.docker.com/repository/docker/openscapes/corn/tags?page=1&ordering=last_updated"><img src="https://img.shields.io/docker/v/openscapes/corn"></a>

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

> Note: if you have pip installable depencencies, they must be listed using a `requirements.txt` file.

<!-- [![badge](https://img.shields.io/static/v1.svg?logo=Jupyter&label=Openscapes&message=AWS+us-west-2&color=orange)](https://openscapes.2i2c.cloud/hub/user-redirect/git-pull?repo=https%3A%2F%2Fgithub.com%2FNASA-Openscapes%2F2021-Cloud-Hackathon&urlpath=lab%2Ftree%2F2021-Cloud-Hackathon%2Ftutorials&branch=main) --> 

## Using a Kernel

After we commit our changes to this repo, the Github Action will push the resulting Docker image to [dockerhub](https://hub.docker.com/repository/docker/openscapes/corn). This can take ~20 minutes. Then, we need to update the user image in our Jupyterhub configuration (admin > Services > configurator)(right now it's hard-coded to `openscapes/corn:$TAG`, previously was `betolink`.) For 2i2c deployments there is a GUI that allows administrators to do it.

![configurator](https://user-images.githubusercontent.com/717735/139174138-f6eb011e-9cc5-4c15-af68-d77ae5d7ee00.png)

Then, you'll go to <https://openscapes.2i2c.cloud/hub/home> > Stop My Server (or File > Log Out) to stop your server and restart it. Then the Docker image should be updated.

For other Jupyterhub deployments we can change the image using the hub configurator object or even in a Kubernetes chart.

> Note: Looks like 2i2c caches the user image so tags like `main` won't be updated even if they have changes. Using the actual commit hash is a better practice for now.

## What's next?

This is a effective but probably inefficient way of building environments, exploring staged partial builds in Docker or using [conda-store](https://github.com/Quansight/conda-store) to build each environment and then pulling them into a Docker image may be more efficient.

The final size of the image depends on the dependencies for each environment, thus avoiding multiple Python versions is still recommended.

