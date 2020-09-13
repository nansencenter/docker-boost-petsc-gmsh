# docker-boost-petsc-gmsh
Docker images for building boost, petsc and gmsh libraries and installing Python libraries

# Building tips
```
# build a base image with compilers, libopenmpi, etc
docker build . -t boost_petsc_gmsh:base --target base
# build the image with boost, petsc, gmsh
docker build . -t boost_petsc_gmsh:0.0.6
# tag the image (41690ad26ab5 is image id)
docker tag  41690ad26ab5 nansencenter/boost_petsc_gmsh:0.0.6
# login and push the image
docker login --username=akorosov
docker push nansencenter/boost_petsc_gmsh:0.0.6
# build, tag and push the conda image
cd docker-boost-petsc-gmsh-conda
docker build . -t boost_petsc_gmsh_conda:0.0.2
docker tag  027ad8379c83 nansencenter/boost_petsc_gmsh_conda:0.0.2
docker push nansencenter/boost_petsc_gmsh_conda:0.0.2
```
