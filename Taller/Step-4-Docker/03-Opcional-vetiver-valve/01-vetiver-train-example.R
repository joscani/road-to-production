library(tidyverse)
library(vetiver)
library(tidymodels)
library(pins)
library(plumber)
library(xgboost)
library(bundle)
library(valve)

tidymodels_prefer()

board <- board_folder(here::here("Taller/modelos/modelo_vetiver/"), versioned = TRUE)
data(Chicago)

n <- nrow(Chicago)
Chicago <- Chicago %>% select(ridership, Clark_Lake, Quincy_Wells)

Chicago_train <- Chicago[1:(n - 7), ]
Chicago_test <- Chicago[(n - 6):n, ]


bt_recipe <- recipe(ridership ~ ., data = Chicago_train)

bt_reg_spec <-
  boost_tree(trees = 15) %>%
  # This model can be used for classification or regression, so set mode
  set_mode("regression") %>%
  set_engine("xgboost")


bt_workflow <- workflow() %>%
  add_recipe(bt_recipe) %>%
  add_model(bt_reg_spec)

bt_fit <- fit(bt_workflow, data = Chicago_train)

class(bt_fit)

vet_model_xg <- bt_fit %>%
  vetiver_model(model_name = "mod_vetiver_valve")

board %>% vetiver_pin_write(vet_model_xg)

pins::pin_versions(board = board, name = "mod_vetiver_valve")

# arguments explain in https://valve.josiahparry.com/

docker_dir_valve <- here::here("Taller/Step-4-Docker/03-Opcional-vetiver-valve/docker_valve")
fs::dir_create(docker_dir_valve)
setwd(docker_dir_valve)

# crear el plumber
vetiver_write_plumber(board, "mod_vetiver_valve")

valve::valve_write_vetiver(vet_model_xg, port = 8000,
                           plumber_file = "plumber.R",
                           workers = 3, n_max = 3,
                           check_unused = 10, max_age = 300)

system("nohup docker container run --rm -p 8083:8000 valve-docker > valve-docker.out 2>&1 &")
