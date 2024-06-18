FROM pangeo/base-image:2023.01.13
# build file for pangeo images
RUN conda init zsh && conda init bash

COPY --chown=jovyan:jovyan . /home/jovyan/.kernels

USER root

ENV QUARTO_CLI=https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.433/quarto-1.3.433-linux-amd64.deb

RUN wget -O /tmp/quarto.deb ${QUARTO_CLI} && dpkg -i /tmp/quarto.deb && rm -rf /tmp/quarto.deb && apt-get clean

USER ${NB_USER}

WORKDIR ${HOME}/.kernels

RUN chmod +x install-kernels.sh && cd /home/jovyan/.kernels && ./install-kernels.sh environments

RUN mkdir -p /opt/code-server/extensions && \
    echo "extensions-dir=/opt/code-server/extensions" >> $HOME/.config/code-server/config.yaml && \
    EXT_LIST="ms-python.python quarto.quarto" && \
    for EXT in $EXT_LIST; do code-server --install-extension $EXT; done

ENV JUPYTERHUB_HTTP_REFERER=https://openscapes.2i2c.cloud/

