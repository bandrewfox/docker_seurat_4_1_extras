FROM ghcr.io/bandrewfox/docker_seurat_4_1_extras:main

# If there is a wget download error, then go to this page and make sure the RSTUDIO_VERSION 
# you specify above is valid: https://dailies.rstudio.com/version/2022.02.0+443.pro2/
ENV RSTUDIO_VERSION=2022.02.0-443
ENV DEFAULT_USER=rstudio
ENV PATH=/usr/lib/rstudio-server/bin:$PATH
RUN /rocker_scripts/install_rstudio.sh
EXPOSE 8787

RUN pip install 'scanpy[leiden]'
RUN pip install numpy==1.21
RUN pip install decoupler==1.3.3

CMD ["/init"]

# to build:
# docker build -t rstudio .

# to run:
# docker run -e PASSWORD=mypass -p 8787:8787 --rm -v /home/ec2-user:/home/ec2-user -e USERID=$UID -d rstudio

# In your browser, visit ec2_ip_address:8787 and login with username rstudio and password mypass

