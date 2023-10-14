##

library(tidyverse)
library(ggdist)

library(furrr)
plan(multisession, workers = 6, .cleanup = FALSE)
# options(future.rng.onMisuse="ignore") # future iessu

test <-  read_csv("/media/hd1/canadasreche@gmail.com/mi_blog/data/test_local.csv")

base_url <- "http://joscaniplumber.bzdcdcgzhxb0fpd3.eastus.azurecontainer.io:8080"

api_res <- httr::POST(url = paste0(base_url, "/full_posterior"),
                      body = test[1:2,],
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

full_posterior <- jsonlite::fromJSON(predicted_values)

full_posterior %>%
  ggplot(aes(x = .epred, y = as_factor(.row))) +
  stat_halfeye()


predict_with_plumber <- function(port, test, endpoint="/predict"){
  base_url <- "http://joscaniplumber.bzdcdcgzhxb0fpd3.eastus.azurecontainer.io:"
  test_json = jsonify::to_json(test)

  api_res <- httr::POST(url = paste0(base_url, port, endpoint),
                        body = test_json,
                        encode = "raw")
  predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
  RcppSimdJson::fparse(predicted_values)
}

# nohup docker container run --rm -p 8082:8082 r-minimal-plumber_async &
start <- Sys.time()
multiple_users_sequential <- future_map(1:6, ~ predict_with_plumber(8080,head(test), "/predict"))

(multiple_users_sequential_time <-  Sys.time() - start)


start <- Sys.time()
multiple_users_async <- future_map(1:6, ~ predict_with_plumber(8080,head(test), "/predict_async"))

(multiple_users_async_time <-  Sys.time() - start)






