library(tidyverse)
library(vetiver)
library(tidymodels)
library(pins)
library(plumber)
library(xgboost)
library(bundle)
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
  vetiver_model(model_name = "bt_xgboost")

board %>% vetiver_pin_write(vet_model_xg)

pins::pin_versions(board = board, name = "bt_xgboost")

pin

miboard_s3 <-  board_s3(bucket = "taller-barna-ireland", region = "eu-west-1")

miboard_s3 %>% vetiver_pin_write(vet_model_xg)

pins::pin_versions(board = miboard_s3, name = "bt_xgboost")
