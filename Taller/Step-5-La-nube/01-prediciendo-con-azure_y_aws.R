##

library(tidyverse)
library(ggdist)

test <-  read_csv(here::here("Taller/data/test_local.csv"))

predict_with_plumber <- function( base_url, test, endpoint="/predict"){
  test_json = jsonify::to_json(test)

  api_res <- httr::POST(url = paste0(base_url, endpoint),
                        body = test_json,
                        encode = "raw")
  predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
  RcppSimdJson::fparse(predicted_values)
}

## AZURE ----

### Container a pelo, sin https y puerto 8080----

container_url <- "http://joscaniplumber.bzdcdcgzhxb0fpd3.eastus.azurecontainer.io:8080"

# tarda un poco porque en esa api metí un Sys.sleep(10)
pred_container <- predict_with_plumber(container_url, head(test), endpoint = "/predict")
pred_container


### Azure app services , el proveedor pone https y puerto 80-----

app_service_url <- "https://bayesianplumber.azurewebsites.net"

# tarda un poco porque en esa api metí un Sys.sleep(10)
pred_app <- predict_with_plumber(app_service_url, head(test), endpoint = "/predict")
pred_app

full_posterior <- predict_with_plumber(app_service_url, head(test), endpoint = "/full_posterior")
full_posterior %>%
  ggplot(aes(x = .epred, y = as_factor(.row))) +
  stat_halfeye()


### Simulamos 3 usuarios a la vez atacando a la api -----

library(furrr)
plan(multisession, workers = 3, .cleanup = FALSE)
options(future.rng.onMisuse = "ignore") # future issue

start <- Sys.time()
multiple_users_sequential <- future_map(1:3, ~ predict_with_plumber(app_service_url, head(test), "/predict"))
(multiple_users_sequential_time <-  Sys.time() - start)

start <- Sys.time()
multiple_users_async <- future_map(1:3, ~ predict_with_plumber(app_service_url, head(test), "/predict_async"))
(multiple_users_async_time <-  Sys.time() - start)



## AWS 1 vCPU & 2 GB, pero tiene autoscaling,ver config -----

aws_url <- "https://46vrd9dczj.eu-west-1.awsapprunner.com"

start <- Sys.time()
multiple_users_sequential <- future_map(1:3, ~ predict_with_plumber(aws_url, head(test), "/predict"))
(multiple_users_sequential_time <-  Sys.time() - start)


start <- Sys.time()
multiple_users_async <- future_map(1:3, ~ predict_with_plumber(aws_url, head(test), "/predict_async"))
(multiple_users_async_time <-  Sys.time() - start)



