FROM pangeo/base-image:2024.08.18
# build file for pangeo images
RUN conda init zsh && conda init bash

COPY --chown=jovyan:jovyan . /home/jovyan/.kernels

USER ${NB_USER}

WORKDIR ${HOME}/.kernels

RUN chmod +x install-kernels.sh && cd /home/jovyan/.kernels && ./install-kernels.sh environments

RUN chmod +x install-vscode-ext.sh && ./install-vscode-ext.sh vscode-extensions.txt

ENV JUPYTERHUB_HTTP_REFERER=https://openscapes.2i2c.cloud/

