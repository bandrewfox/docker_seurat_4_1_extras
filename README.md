# Extra pacakges on top of a recent seurat docker image

Using seurat since it starts with rocker and also has some useful packages already
installed. This is a timesaver for Needle Genomics clients and allows for a consistent
set of R packages and libraries to be used by the app. This takes around 2 hrs to build.

This Dockerfile also has some handy tricks for trying to make the build more repeatable
by using MRAN.

These are the docker images that I use, with the first one being the one I have in FROM,
and that one uses the one below as FROM, etc

* https://github.com/satijalab/seurat-docker
* https://github.com/Bioconductor/bioconductor_docker
* https://rocker-project.org/


To create a new version, put these files in an empty directory and create a new repo with it:

    Dockerfile
    bioc_install.R
    .github/workflows/docker-publish.yml

Create a new repository: https://github.com/new

# How to run it

Here are some notes I saved for building a new AWS Linux 2.0 instance to run this docker image.

## Install docker on a new instance

    # connect to your running instance
    ssh -i mykey.pem ec2-user@1.2.3.4

    # apply updates
    sudo yum update -y

    # install docker
    sudo amazon-linux-extras install -y docker

    # install git (try the first, if that doesn't work, do the second one)
    sudo yum install -y git

    # give ec2-user permission to start/stop docker containers
    sudo usermod -a -G docker ec2-user

    # run docker as a service (may need to figure out how to have this run when VM starts up)
    sudo service docker start

    # log out and log in to get group perm, then next command should not be an error
    exit
    ssh -i mykey.pem ec2-user@1.2.3.4
    docker info   # this should now work with no errors

## enable rstudio

If you try running the Dockerfile in this repo, then you will get an error like this because
/init is a command which will only run after you install rstudio:

    docker: Error response from daemon: failed to create shim task: OCI runtime create failed:
    runc create failed: unable to start container process: exec: "/init": stat
    /init: no such file or directory: unknown.

So, to use rstudio, go to the rstudio directory and build the Dockerfile to an image and run it:

    # pull this image (optional - will happen anyway later)
    docker pull ghcr.io/bandrewfox/docker_seurat_4_1_extras:main

    # need to be in the rstudio dir
    cd rstudio

    # build the new docker image with rstudio enabled
    docker build -t rstudio .

    # docker run command
    docker run -e PASSWORD=mypass -p 8787:8787 --rm -v /home/ec2-user:/home/ec2-user -e USERID=$UID -d rstudio

Then you can go to your ec2 instance with :8787 at the end and login with username rstudio and password mypass


