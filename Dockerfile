
# Using pocl_ubuntu build
FROM nvidia/cuda:8.0-devel-ubuntu14.04

# Make port 80 available to the world outside this container
EXPOSE 80

ENV BACKEND=CUDA

RUN apt-get update
RUN apt-get install -y --force-yes apt-transport-https
RUN apt-get install -y --force-yes libcurl4-openssl-dev libssl-dev libxml2-dev

#apt-key adv --recv-key --keyserver keyserver.ubuntu.com E084DAB9

RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu/ trusty/" >> /etc/apt/sources.list; \
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key E084DAB9
    
RUN apt-get install -y --force-yes software-properties-common
RUN add-apt-repository ppa:marutter/rrutter
RUN apt-get update

RUN apt-get install -y --force-yes r-base r-base-dev
RUN apt-get install -y --force-yes git
	

RUN git config --global user.email "cdetermanjr@gmail.com"; \
	git config --global user.name "Charles Determan"
	
# setup R configuration and install packages
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'https://cran.rstudio.com'; options(repos = r);" > ~/.Rprofile
RUN Rscript -e "install.packages(c('devtools', 'testthat', 'roxygen2', 'stringi'))"
RUN Rscript -e "devtools::install_github('RcppCore/Rcpp')"
RUN Rscript -e "devtools::install_github('wrathematics/thrust')"
RUN Rscript -e "devtools::install_github('gpuRcore/gpuRcuda')"

RUN git clone https://github.com/gpuRcore/gpuRcublas.git
RUN chmod 777 gpuRcublas/configure

RUN R CMD INSTALL gpuRcublas/


