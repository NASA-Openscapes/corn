FROM pangeo/base-image:2024.03.22
# build file for pangeo images
RUN conda init zsh && conda init bash

COPY --chown=jovyan:jovyan . /home/jovyan/.kernels

WORKDIR ${HOME}/.kernels

RUN chmod +x install-kernels.sh && cd /home/jovyan/.kernels && ./install-kernels.sh environments

ENV JUPYTERHUB_HTTP_REFERER=https://openscapes.2i2c.cloud/

