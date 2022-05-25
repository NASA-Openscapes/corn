FROM pangeo/base-image:2021.09.30
# build file for pangeo images

# FIXME (?): user and home folder is hardcoded for now
# FIXME (?): this line breaks the cache of all steps below
COPY --chown=jovyan:jovyan . /home/jovyan/.kernels

USER root

RUN wget -O quarto.deb https://github.com/quarto-dev/quarto-cli/releases/download/v0.9.449/quarto-0.9.449-linux-amd64.deb && dpkg -i quarto.deb

USER ${NB_USER}

RUN conda init zsh && conda init bash

WORKDIR ${HOME}/.kernels
RUN chmod +x install-kernels.sh && cd /home/jovyan/.kernels && ./install-kernels.sh environments
ENV JUPYTERHUB_HTTP_REFERER=https://openscapes.2i2c.cloud/



