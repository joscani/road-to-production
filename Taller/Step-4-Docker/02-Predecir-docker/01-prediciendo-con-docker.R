## Arrancamos dockers creados con rocker-verse


## Arrancar docker creados------

# Si ya lo hemos arrancado antes no hace falta lanzar de nuevo el nohup
system("nohup docker container run --rm -p 8083:8000 taller_docker > taller.out 2>&1 &")



library(tidyverse)


test <-  read_csv(here::here("Taller/data/test_local.csv"))
test

# Elegimos algunas filas

(to_predict <-  test %>%
  filter(segmento == "Best" & valor_cliente == 3 ) %>%
  slice_head(n = 3) %>%
  bind_rows(test %>%
              filter(segmento == "Neut" ) %>%
              slice_head(n = 3)) )



## Predecir con la api dockerizada-----
base_url <- "http://0.0.0.0:8083"
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
  ggplot(aes(x = .epred, y = as_factor(.row))) +
  ggdist::stat_halfeye(aes(fill = as_factor(.row))) +
  scale_fill_viridis_d(option = "rocket") +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Posterior predictive distribution using plumber API",
    y = "Cliente", x = "Posterior prediction, in %",
    fill = "Cliente") +
  theme_minimal()

## multiples containers, misma imagen-----

system("nohup docker run -v /media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/Taller/Step-4-Docker/modelo_1/:/opt/ml --rm -p 8084:8000 taller_docker_with_volume > taller_mod1.out 2>&1 &")

system("nohup docker run -v /media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/Taller/Step-4-Docker/modelo_2/:/opt/ml --rm -p 8085:8000 taller_docker_with_volume > taller_mod2.out 2>&1 &")

base_url <- "http://0.0.0.0:8084"
api_res <- httr::POST(url = paste0(base_url, "/predict"),
                      body = to_predict,
                      encode = "json")
predicted_values <- httr::content(api_res, as = "text", encoding = "UTF-8")

jsonlite::fromJSON(predicted_values)


system("docker stop $(docker ps -a -q)")
