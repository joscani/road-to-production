##
 # arrancar minikube
# minikube start
# alias kubectl="minikube kubectl --"
# kubectl get pods
# kubectl get services
# minikube  service plumber-on-k8s-service
library(tidyverse)

library(furrr)
plan(multisession, workers = 6, .cleanup = FALSE)
# options(future.rng.onMisuse="ignore") # future iessu

test <-  read_csv(here::here("data/test_local.csv"))

base_url <- "http://192.168.49.2:30296"

api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = head(test),
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)


api_res2 <- httr::POST(url = paste0(base_url, "/full_posterior"),
                       body = head(test),
                       encode = "json")
posterior_values <- httr::content(api_res2, as = "text", encoding = "UTF-8")


jsonlite::fromJSON(posterior_values)  %>%
  head(100)


# simular varios procesos a la vez  para ver como sería varios usuarios atacando a la vez



predict_with_plumber <- function(port, test, endpoint="/predict"){
  base_url <- "http://192.168.49.2:"
  test_json = jsonify::to_json(test)

  api_res <- httr::POST(url = paste0(base_url, port, endpoint),
                        body = test_json,
                        encode = "raw")
  predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
  RcppSimdJson::fparse(predicted_values)
}

# nohup docker container run --rm -p 8082:8082 r-minimal-plumber_async &
start <- Sys.time()
multiple_users_sequential <- future_map(1:6, ~ predict_with_plumber(30296,head(test), "/predict"))

(multiple_users_sequential_time <-  Sys.time() - start)


start <- Sys.time()
multiple_users_async <- future_map(1:6, ~ predict_with_plumber(30296,head(test), "/predict_async"))

(multiple_users_async_time <-  Sys.time() - start)



## con datos diferentes cada usuario

x <- list(1,2,3,4)
y <- list(test[1:3,], test[4:6,], test[7:9,], test[10:20,])
y


start <- Sys.time()
multiple_users_async <- future_map2(.x = x,.y = y,  ~ predict_with_plumber(8082,test = .y, "/predict_async"))

(multiple_users_async_time <-  Sys.time() - start)





