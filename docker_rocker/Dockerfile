# Docker file para modelo brms

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
     && Rscript -e "options(install.opts = c('--no-help', '--no-docs'))" \
     && Rscript -e "renv::restore(lockfile = 'renv.lock')"

EXPOSE 8080
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('/opt/ml/plumber.R'); pr$run(host = '0.0.0.0', port = 8080)"]

