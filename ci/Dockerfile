FROM pangeo/base-image:2023.01.13
# build file for pangeo images
RUN conda init zsh && conda init bash

COPY --chown=jovyan:jovyan . /home/jovyan/.kernels

USER root

ENV QUARTO_CLI=https://github.com/quarto-dev/quarto-cli/releases/download/v1.4.555/quarto-1.4.555-linux-amd64.deb
    
RUN wget -O /tmp/quarto.deb ${QUARTO_CLI} && dpkg -i /tmp/quarto.deb && rm -rf /tmp/quarto.deb && apt-get clean

USER ${NB_USER}

WORKDIR ${HOME}/.kernels

RUN chmod +x install-kernels.sh && cd /home/jovyan/.kernels && ./install-kernels.sh environments

RUN chmod +x install-vscode-ext.sh && ./install-vscode-ext.sh vscode-extensions.txt

ENV JUPYTERHUB_HTTP_REFERER=https://openscapes.2i2c.cloud/

