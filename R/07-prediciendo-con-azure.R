##

library(tidyverse)
library(ggdist)

library(furrr)
plan(multisession, workers = 6, .cleanup = FALSE)
# options(future.rng.onMisuse="ignore") # future iessu

test <-  read_csv(here::here("data/test_local.csv"))

# puedes ponerlo como un container  o en azure servirlo como webapp
base_url <- "http://joscaniplumber.bzdcdcgzhxb0fpd3.eastus.azurecontainer.io:8080"
base_url <- "https://bayesianplumber.azurewebsites.net"
base_url <- "https://plumberrockerverse.azurewebsites.net"



api_res <- httr::POST(url = paste0(base_url, "/full_posterior"),
                      body = test[1:2,],
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

full_posterior <- jsonlite::fromJSON(predicted_values)

full_posterior %>%
  ggplot(aes(x = .epred, y = as_factor(.row))) +
  stat_halfeye()
