FROM pangeo/base-image:2024.08.18
# build file for pangeo images
RUN conda init zsh && conda init bash

USER root
COPY --chmod=755 install-positron.sh ./
RUN ./install-positron.sh

# To test locally, put the license file in ci/positron-license.lic and uncomment 
# the line below to copy it into the image. Do not commit the license file to git.
# COPY positron-license.lic /opt/positron-server/resources/activation/linux/x86_64/license.lic

USER ${NB_USER}

COPY --chmod=755 install-vscode-ext.sh ./
COPY vscode-extensions.txt ./
RUN ./install-vscode-ext.sh vscode-extensions.txt

ENV JUPYTERHUB_HTTP_REFERER=https://openscapes.2i2c.cloud/
