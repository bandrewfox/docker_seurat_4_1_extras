#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# figure out which packages haven't been installed yet
mylibs = c()
for (mylib in args) {
    if(! mylib %in% installed.packages()[,'Package']) {
        write(paste("bioc_install.R: to be intalled:", mylib), stderr())
        mylibs = c(mylibs, mylib)
    } else {
        write(paste("bioc_install.R: already installed:", mylib), stderr())
    }
}

# install the packages
write(paste("bioc_install.R: installing: ", paste(mylibs, collapse=", ")), stderr())
BiocManager::install(mylibs, update=F)

# check if any failed
installed = mylibs %in% installed.packages()[,'Package']
if (! all(installed)) {
    stop(paste("bioc_install.R: some packages not installed:", paste(mylibs[!installed], collapse=",")))
}

# done
write("bioc_install.R: all packages installed", stderr())
