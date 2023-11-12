## Valve

[valve`](https://valve.josiahparry.com/) permite crear aplicaciones plumber multihilo. Por debajo usa `Rust` . Llamando al mismo puerto por debajo valve arrancará tantos plumbers como le hayas indicado como máximo y terminarán si no se usan. 

En este contenido opcional, se verá como crear una imagen docker que use valve. La librería tiene funciones interesantes que se llevan bien con las de `vetiver`

Ejemplo 

```r
# crear el plumber a partir de un modelo de tidymodels guardado con vetiver
vetiver_write_plumber(board, "mod_vetiver_valve")

valve::valve_write_vetiver(vet_model_xg, port = 8000,
                           plumber_file = "plumber.R",
                           workers = 3, n_max = 3,
                           check_unused = 10, max_age = 300)
```

Y eso crearía un Dockerfile tal que así

```

FROM rocker/r-ver:4.3.2
ENV RENV_CONFIG_REPOS_OVERRIDE https://packagemanager.rstudio.com/cran/latest

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  libcurl4-openssl-dev \
  libicu-dev \
  libsodium-dev \
  libssl-dev \
  make \
  zlib1g-dev \
  && apt-get clean

COPY vetiver_renv.lock renv.lock
RUN Rscript -e "install.packages('renv')"
RUN Rscript -e "renv::restore()"
COPY plumber.R /opt/ml/plumber.R
EXPOSE 8000

# Install Rust toolchain & add to the path
RUN apt-get install -y -q \
    build-essential \
    curl  
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Valve binary from Github
RUN cargo install valve-rs --no-default-features

# Start Valve app
ENTRYPOINT valve -f /opt/ml/plumber.R -h 0.0.0.0 -p 8000 --workers 3 --n-max 3 --check-unused 10 --max-age 300
```
