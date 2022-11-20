# Extra pacakges on top of a recent seurat docker image

Using seurat since it starts with rocker and also has some useful packages already
installed. This is a timesaver for Needle Genomics clients and allows for a consistent
set of R packages and libraries to be used by the app. This takes around 2 hrs to build.

This Dockerfile also has some handy tricks for trying to make the build more repeatable
by using MRAN.

https://rocker-project.org/
https://github.com/satijalab/seurat-docker
https://github.com/Bioconductor/bioconductor_docker


To create a new version, put these files in an empty directory:
    Dockerfile
    bioc_install.R
    .github/workflows/docker-publish.yml

Create a new repository: https://github.com/new


