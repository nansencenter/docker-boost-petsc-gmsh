# docker-boost-petsc-gmsh
Docker images for building boost, petsc and gmsh libraries and installing Python libraries

# Building tips
```
# first build a base image with compilers, libopenmpi, etc
docker build . -t boost_petsc_gmsh:base --target base
# then build the image with boost, petsc, gmsh
docker build . -t boost_petsc_gmsh:0.0.5
# then tag the image (41690ad26ab5 is image id)
docker tag  41690ad26ab5 akorosov/boost_petsc_gmsh:0.0.5
# then login and push the image
docker login --username=akorosov
docker push akorosov/boost_petsc_gmsh:0.0.5
# then build, tag and push the conda image
cd docker-boost-petsc-gmsh-conda
docker build . -t boost_petsc_gmsh_conda:0.0.1
docker tag  027ad8379c83 akorosov/boost_petsc_gmsh_conda:0.0.1
docker push akorosov/boost_petsc_gmsh_conda:0.0.1
```
