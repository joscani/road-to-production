# Docker file para modelo brms
# [+] Building 473.4s (10/10) FINISHED                                   docker:default

FROM rocker/r-ver:4.3.1
ENV RENV_CONFIG_REPOS_OVERRIDE https://packagemanager.rstudio.com/cran/latest

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  default-jdk \
  libcurl4-openssl-dev \
  libicu-dev \
  libsodium-dev \
  libssl-dev \
  make \
  zlib1g-dev \
  libxml2-dev \
  libglpk-dev \
  && apt-get clean

COPY renv_simplify.lock brms_model.rds plumber_without_async.R launch.R ./

RUN  mkdir /opt/ml \
     && mv renv_simplify.lock renv.lock \
     && mv brms_model.rds /opt/ml/brms_model.rds \
     && mv plumber_without_async.R /opt/ml/plumber.R \
     && Rscript -e "install.packages('renv')" \
     && Rscript -e "options(install.opts = c('--no-help', '--no-docs')); renv::restore(lockfile = 'renv.lock')"


EXPOSE 8000
CMD R -e "source('launch.R')"


# setup nginx-------------------------------------------------------------
# RUN apt-get update && \
#apt-get install -y nginx apache2-utils && \
#    htpasswd -bc /etc/nginx/.htpasswd test test


# RUN openssl req -batch -x509 -nodes -days 365 -newkey rsa:2048 \
#        -keyout /etc/ssl/private/server.key \
#        -out /etc/ssl/private/server.crt


# ADD ./nginx.conf /etc/nginx/nginx.conf

# EXPOSE 80
# CMD service nginx start && R -e "source('launch.R')"

