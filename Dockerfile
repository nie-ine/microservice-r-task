FROM ubuntu:18.04

# Setting locales
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
## Otherwise timedatectl will get called which leads to 'no systemd' inside Docker
ENV TZ UTC

# Install software-properties-common (needed to do apt-add-repository)
RUN apt-get update && apt-get install -y --no-install-recommends \
software-properties-common

# Install stuff
RUN apt-get update && apt-get install -y --no-install-recommends \
python3 \
python3-pip \
r-base \
r-base-dev \
r-recommended

# Install R packages
RUN R -e 'install.packages("tidyverse", repos = "http://cran.rstudio.com/")' \
	# ggplot2
    # dplyr
    # tidyr
    # readr
    # purrr
    # tibble
    # stringr
    # forcats
&& R -e 'install.packages("lubridate", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("XML", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("jsonlite", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("rjson", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("data.table", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("zoo", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("xts", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("quantmod", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("sp", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("maptools", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("maps", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("ggmap", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("xtable", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("graphics", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("ggivs", repos = "http://cran.rstudio.com/")' \
&& R -e 'install.packages("htmlwidgets", repos = "http://cran.rstudio.com/")' \
    # leaflet
    # dygraphs
    # DT
    # diagrammeR
    # network3D
    # threeJS
&& R -e 'install.packages("maps", repos = "http://cran.rstudio.com/")' \
&& rm -rf /tmp/downloaded_packages/ /tmp/*.rds


# Make microservice directories
RUN mkdir -p /ms/r /ms/r/static /ms/r/templates

# Copy flask stuff
COPY static/. /ms/r/static/
COPY templates/. /ms/r/templates/
COPY r-task.py requirements.txt /ms/r/

# Set wd
WORKDIR /ms/r

# Setup flask microservice
RUN pip3 install setuptools
RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --upgrade lxml

# Run microservice
CMD [ "python3", "r-task.py" ]