FROM satijalab/seurat:4.1.0

# Satija's Dockerfile starts with rocker/r-ver:4.1.0:
# https://github.com/satijalab/seurat-docker/blob/master/latest/Dockerfile

# and the rocker project has a nice simple way to update a base rocker container with rstudio:
# https://github.com/rocker-org/rocker-versioned2/blob/master/dockerfiles/rstudio_4.1.2.Dockerfile
ENV S6_VERSION=v2.1.0.2
ENV PANDOC_VERSION=default

# pick the date closest to the seurat docker version release date
# tidyverse and other R package installation should use this MRAN date
ENV MRAN_BUILD_DATE=2022-03-10
ENV CRAN=https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE}

# run scripts from rocker to install pandoc and tidyverse
RUN /rocker_scripts/install_pandoc.sh
RUN /rocker_scripts/install_tidyverse.sh

# uncomment if you want rstudio:
# If there is a wget download error, then go to this page and make sure the RSTUDIO_VERSION you specify above is valid: https://dailies.rstudio.com/version/2022.02.0+443.pro2/
#ENV RSTUDIO_VERSION=2022.02.0-443
#ENV DEFAULT_USER=rstudio
#ENV PATH=/usr/lib/rstudio-server/bin:$PATH
#RUN /rocker_scripts/install_rstudio.sh
#EXPOSE 8787

# nlopt needed for ggpubr
RUN apt update && apt install -y libnlopt-dev

# Got this approach from: https://towardsdatascience.com/reproducible-work-in-r-e7d160d5d198
RUN install2.r -r https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE} --error caret openxlsx glmnet \
                     corrplot igraph apcluster beeswarm httr data.table reshape2 gplots png ggbeeswarm \
                     gridExtra gridGraphics cowplot
RUN install2.r -r https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE} --error ggpubr
RUN install2.r -r https://cran.microsoft.com/snapshot/${MRAN_BUILD_DATE} --error survminer

# This script will return an error if the install fails and then docker build will stop
COPY bioc_install.R /tmp
RUN Rscript --vanilla /tmp/bioc_install.R limma DESeq2 edgeR
RUN Rscript --vanilla /tmp/bioc_install.R org.Hs.eg.db org.Mm.eg.db org.Rn.eg.db
RUN Rscript --vanilla /tmp/bioc_install.R UpSetR VennDiagram GeneOverlap
RUN Rscript --vanilla /tmp/bioc_install.R GEOquery
RUN Rscript --vanilla /tmp/bioc_install.R fgsea GSVA msigdb
RUN Rscript --vanilla /tmp/bioc_install.R ComplexHeatmap

CMD ["/init"]

