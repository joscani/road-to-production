FROM rocker/r-ver:4.3.1
ENV RENV_CONFIG_REPOS_OVERRIDE https://packagemanager.rstudio.com/cran/latest

# instalamos librerias de sistema

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

# Intalamos librerías de R , hay motivo para copiar primero el renv primero las librerias y luego los ficheros
COPY renv_simplify.lock ./

RUN  Rscript -e "install.packages('renv')" \
     && Rscript -e "options(install.opts = c('--no-help', '--no-docs')); renv::restore(lockfile = 'renv_simplify.lock')"



# copiamos modelos, plumber y lanzador

COPY brms_model.rds plumber_async.R launch.R ./

# copiamos modelo, plumber  y lanzador a /opt/ml
RUN  mkdir /opt/ml \
     && mv brms_model.rds /opt/ml/brms_model.rds \
     && mv launch.R /opt/ml/launch.R \
     && mv plumber_async.R /opt/ml/plumber.R


EXPOSE 8000
CMD R -e "source('/opt/ml/launch.R')"


