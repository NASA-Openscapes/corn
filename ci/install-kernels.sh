#!/bin/bash

dirlist=$(find $1 -mindepth 1 -maxdepth 1 -type d)
CONDA_DIR=/srv/conda

for dir in $dirlist
do
  (
  cd $dir \
  ; CONDA_ENV=$(cat name.txt) \
  ; NB_PYTHON_PREFIX=${CONDA_DIR}/envs/$CONDA_ENV \
  ; echo "Installing $CONDA_ENV ..." \
  ; if test -f "conda-linux-64.lock" ; then \
  mamba create --name ${CONDA_ENV} --file conda-linux-64.lock \
  ; elif test -f "environment.yml" ; then \
  conda-lock lock --mamba -f environment.yml -p linux-64 &&
  mamba create --name ${CONDA_ENV} --file conda-linux-64.lock  \
  ; else echo "No conda-linux-64.lock or environment.yml! *creating default env*" ; \
  mamba create --name ${CONDA_ENV} pangeo-notebook \
  ; fi \
  && mamba clean -yaf \
  && find ${CONDA_DIR} -follow -type f -name '*.a' -delete \
  && find ${CONDA_DIR} -follow -type f -name '*.pyc' -delete \
  && find ${CONDA_DIR} -follow -type f -name '*.js.map' -delete \
  ; [ -d ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static ] && find ${NB_PYTHON_PREFIX}/lib/python*/site-packages/bokeh/server/static -follow -type f -name '*.js' ! -name '*.min.js' -delete \
  ; echo "Checking for pip 'requirements.txt'..." \
  ; if test -f "requirements.txt" ; then \
  ${NB_PYTHON_PREFIX}/bin/pip install --no-cache-dir -r requirements.txt \
  ; fi \
  ; source activate ${CONDA_ENV} \
  ; python -m ipykernel install --prefix /srv/conda/envs/notebook --name ${CONDA_ENV} --display-name ${CONDA_ENV}
  )
done
rm -rf ${HOME}/environments ${HOME}/Dockerfile ${HOME}/apt.txt ${HOME}/environment.yml ${HOME}/start ${HOME}/install-kernels.sh
