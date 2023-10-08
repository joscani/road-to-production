
# Docker file para modelo brms

FROM rhub/r-minimal:4.3.1

RUN installr -d -a linux-headers ps \
     && installr -d -a "curl-dev gcc linux-headers gfortran libcurl libxml2 libsodium-dev libsodium automake autoconf" \
     && installr -d Matrix MASS mgcv future codetools brms plumber tidybayes

RUN installr -d RcppSimdJson

## Copio el modelo y el fichero de la api


COPY  brms_model.rds plumber_async_with_sleep.R launch.R ./

RUN  mkdir /opt/ml \
     && mv brms_model.rds /opt/ml/brms_model.rds \
     && mv plumber_async_with_sleep.R /opt/ml/plumber.R


# exponemos el puerto
EXPOSE 8080
ENTRYPOINT ["R", "-e", "pr <- plumber::plumb('/opt/ml/plumber.R'); pr$run(host = '0.0.0.0', port = 8080)"]
