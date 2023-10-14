## Arrancamos dockers creados con rocker-verse


## Arrancar docker creados------

# nohup docker container run --rm -p 8083:8000 r-docker-plumber_nosync > rocker.out 2>&1 &

# nohup docker container run --rm  -p 80:80 -p 443:443 r-docker-plumber_nosync_secure > rocker.out 2>&1 &

# nohup docker container run --rm -p 8082:8080 joscani/r-minimal-plumber_async > minimal_async.out 2>&1 &



library(tidyverse)

library(furrr)
plan(multisession, workers = 6, .cleanup = FALSE)
options(future.rng.onMisuse="ignore") # future issue

test <-  read_csv(here::here("data/test_local.csv"))

test



base_url <- "http://0.0.0.0:8083"
base_url <- "https://localhost"

(to_predict <-  test %>%
  filter(segmento == "Best" & valor_cliente == 3 ) %>%
  slice_head(n = 3) %>%
  bind_rows(test %>%
              filter(segmento == "Neut" ) %>%
              slice_head(n = 3)) )


httr::set_config(httr::config(ssl_verifypeer = 0L, ssl_verifyhost = 0L))



api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = to_predict,
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)


api_res2 <- httr::POST(url = paste0(base_url, "/full_posterior"),
                       body = to_predict,
                       encode = "json")
posterior_values <- httr::content(api_res2, as = "text", encoding = "UTF-8")

posterior_df <- jsonlite::fromJSON(posterior_values)

# 6 clientes x 3000 posterior draws x 4 cadenas MCMC
dim(posterior_df)

posterior_df %>%
  ggplot(aes(x=.epred, y = as_factor(.row))) +
  ggdist::stat_halfeye(aes(fill = as_factor(.row))) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Posterior predictive distribution using plumber API",
    y = "Cliente", x = "Posterior prediction, in %",
    fill = "Cliente")



# Multiples usuarios a la vez ------------
# simular varios procesos a la vez  para ver como sería varios usuarios atacando a la vez



predict_with_plumber <- function(port, test, endpoint="/predict"){
  base_url <- "http://0.0.0.0:"
  test_json = jsonify::to_json(test)

  api_res <- httr::POST(url = paste0(base_url, port, endpoint),
                        body = test_json,
                        encode = "raw")
  predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")
  RcppSimdJson::fparse(predicted_values)
}

# nohup docker container run --rm -p 8082:8082 r-minimal-plumber_async &
start <- Sys.time()
multiple_users_sequential <- future_map(1:6, ~ predict_with_plumber(8082,head(test), "/predict"))

(multiple_users_sequential_time <-  Sys.time() - start)


start <- Sys.time()
multiple_users_async <- future_map(1:6, ~ predict_with_plumber(8082,head(test), "/predict_async"))

(multiple_users_async_time <-  Sys.time() - start)



## con datos diferentes cada usuario

x <- list(1,2,3,4)
y <- list(test[1:3,], test[4:6,], test[7:9,], test[10:20,])
y



start <- Sys.time()
multiple_users_sequential <- future_map2(.x = x,.y = y,  ~ predict_with_plumber(8082,test = .y, "/predict"))

(multiple_users_sequential_time <-  Sys.time() - start)

start <- Sys.time()
multiple_users_async <- future_map2(.x = x,.y = y,  ~ predict_with_plumber(8082,test = .y, "/predict_async"))

(multiple_users_async_time <-  Sys.time() - start)

(multiple_users_async_time <-  Sys.time() - start)





