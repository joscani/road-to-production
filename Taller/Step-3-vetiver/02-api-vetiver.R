library(plumber)
library(tidyverse)
library(vetiver)
library(pins)


board <- board_folder(here::here("Taller/modelos/modelo_vetiver/"), versioned = TRUE)

modelo_reload <- vetiver_pin_read(board, name = "bt_xgboost")

pr() %>%
  vetiver_api(modelo_reload) %>%
  pr_run(port = 8080)


