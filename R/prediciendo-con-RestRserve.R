# predecir en local plumber api.
# arrancar RestRserve.R en segundo plano


library(tidyverse)

test <-  read_csv("/media/hd1/canadasreche@gmail.com/mi_blog/data/test_local.csv")
to_api <-  test[1,]

base_url <- "http://127.0.0.1:8080"

api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = test[3:10,],
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)



predict_with_restrserver <- function(port, test, endpoint="/predict"){
  base_url <- "http://127.0.0.1:"

  api_res <- httr::POST(url = paste0(base_url,port, "/predict"),
                        body = test,
                        encode = "json")
  predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
  RcppSimdJson::fparse(predicted_values)
}

library(future)
plan(sequential)

plan(multisession, workers = 6, .cleanup = FALSE)

# nohup docker container run --rm -p 8082:8082 r-minimal-plumber_async &
start <- Sys.time()
multiple_users_sequential <- future_map(1:4, ~ predict_with_restrserver(8080,head(test), "/predict"))

(multiple_users_sequential_time <-  Sys.time() - start)

