# `Step 3` Vetiver

En este `step` veremos un ejemplo de como entrenar un modelo con `tidymodels` y utilizar `vetiver` para generar la api. 

En el taller de Aitor se verá en más profundidad el funcionamiento de `tidymodels`

## Scripts

* `01-vetiver-train-example.R` : Entrenar un modelo con `tidymodels` y guardarlo tanto en local como en aws s3 (mi s3) junto con sus metadatos

* `02-api-vetiver.R` : Código para la api del modelo. `vetiver` simplifica el uso de plumber. Este código ha de lanzarse en otro proceso de R, ya sea en un nuevo terminal, usando `callr::r_bg` o si estás en Rstudio source as background job

* `03-prediciendo-con-plumber.R`:  Predecir utilizando la api anterior



`vetiver` tiene funciones para ayudarte a generar un docker e incluso para desplegar en AWS Sagemaker. 
