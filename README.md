# docker-boost-petsc-gmsh
Docker image for building boost, petsc and gmsh libraries

# Building tips
```
# first build a base image with compilers, libopenmpi, etc
docker build . -t boost_petsc_gmsh:base --target base
# then build the image with boost, petsc, gmsh
docker build . -t boost_petsc_gmsh:0.0.2
```
