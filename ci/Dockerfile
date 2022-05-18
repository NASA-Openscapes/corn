FROM pangeo/base-image:2022.03.08
# build file for pangeo images
RUN conda init zsh && conda init bash


COPY --chown=jovyan:jovyan . /home/jovyan/.kernels

USER root

RUN julia -e 'using Pkg; Pkg.add("IJulia"); Pkg.build("IJulia")'

ENV QUARTO_CLI=https://github.com/quarto-dev/quarto-cli/releases/download/v0.9.248/quarto-0.9.248-linux-amd64.deb

ENV RSTUDIO_SERVER=https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.02.2-485-amd64.deb

RUN wget -O /tmp/quarto.deb ${QUARTO_CLI} && dpkg -i /tmp/quarto.deb && wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" && add-apt-repository ppa:c2d4u.team/c2d4u4.0+ && apt update && apt install -y --no-install-recommends r-base r-cran-tidyverse && wget -O /tmp/rstudio-server.deb ${RSTUDIO_SERVER} && gdebi --n /tmp/rstudio-server.deb && rm -rf /tmp/rstudio-server.deb /tmp/quarto.deb && apt-get clean

USER ${NB_USER}

WORKDIR ${HOME}/.kernels
RUN chmod +x install-kernels.sh && cd /home/jovyan/.kernels && ./install-kernels.sh environments


ENV JUPYTERHUB_HTTP_REFERER=https://openscapes.2i2c.cloud/

