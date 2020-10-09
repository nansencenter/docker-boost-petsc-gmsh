# docker-nextsim-base
Base image for nextsim, pynextsim, pynextsimf. Contains boost, petsc, gmsh and other useful
libraries including Python libraries.

## Two images

Two images are build using this Dockerfile:

### nextsim_base_pro

Small image with bare minimum for running nextsim, pynextsim and pynextsimf.

### nextsim_base_dev

Large image with many extra libraries and Python packages

## Multi-stage build

The images are build in several stages:
* `builder` image is created with compilers installed.
* `boost`, `gmsh`, `pets` images are built from the `builder` image.
* `conda` image is build for creating and packaging environment for production
* `base` image is build to contain boost, pets, gmsh + few other libs
* `production` image is built from the `base` + Python libs from `conda`
* `development` image is built from `base` + miniconda installation + extra libs

## Building tips

```shell
# build the production image
docker build . -t nextsim_base_pro --target production

# build the development image
docker build . -t nextsim_base_dev --target development

# tag the images (41690ad26ab5 and bf4bd6f278c4 are example image id)
docker tag  41690ad26ab5 nansencenter/nextsim_base_pro:0.0.1
docker tag  bf4bd6f278c4 nansencenter/nextsim_base_dev:0.0.1

# login and push the images
docker login --username=akorosov
docker push nansencenter/nextsim_base_pro:0.0.1
docker push nansencenter/nextsim_base_dev:0.0.1
```
