## corn v2024.03.10
* added jupyter
* Quarto now installs from conda-forge, there is no ARM version.
* conda-lock for OSX and Linux
* updated earthaccess to 0.9.0
* included flox for xarray
* included an opendap kernel to address some issues with v1.9

## corn v2023.08.04
* removed collaboration as is incompatible with Jupyterlab v3.x

## corn v2023.08.03
* added spectral
* added scikit-image
* downgraded to jupyterlab 3.5

## corn v2023.08.02

* using earthaccess v0.5.3
* pinned netcdf to 1.6.4 but still getting libnetcdf 1.9.2 via conda
* added quarto jupyterlab extension
* jupyter-resource-uage got updated to 1.0
* removing pangeo-notebook and using the Jupyter packages directly
* using official docker action to build and push image

