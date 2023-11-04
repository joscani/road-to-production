library(tidyverse)
library(vetiver)
library(tidymodels)
library(pins)
library(plumber)
library(xgboost)
library(bundle)
tidymodels_prefer()

# board <- board_folder(here::here("Taller/modelos/modelo_vetiver/"), versioned = TRUE)
board <-  board_s3(bucket = "taller-barna-ireland", region = "eu-west-1")

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

vet_model_xg <- bt_fit %>%
  # extract_workflow() %>%
  vetiver_model(model_name = "bt_xgboost")

board %>% vetiver_pin_write(vet_model_xg)
board

pin_versions(board, "bt_xgboost")


execution_role <- "arn:aws:iam::969140037785:role/sagemaker-vetiver"
execution_role <- "arn:aws:iam::969140037785:role/service-role/AmazonSageMaker-ExecutionRole-20231102T212751"

name = "bt_xgboost"

# Sends dockerfile to AWS Codebuild for docker build
image_uri <- vetiver_sm_build(
  board =  board,
  name = "bt_xgboost",
  # predict_args = predict_args,
  # docker_args = docker_args,
  repository = glue::glue("joscani_irlanda-{name}:{strftime(Sys.time(), '%Y-%m-%d')}") ,
  bucket = board$bucket,
  role = execution_role
)
