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

vet_model_xg <- bt_fit %>%
  # extract_workflow() %>%
  vetiver_model(model_name = "bt_xgboost")

board %>% vetiver_pin_write(vet_model_xg)

# pr()  %>% vetiver_api(vet_model_xg) %>%
#   pr_run(port = 8080)
#
# pr


miboard_s3 <-  board_s3(bucket = "taller-barna", region = "eu-south-2")

miboard_s3 %>% vetiver_pin_write(vet_model_xg)

### iris ----
iris_split <- initial_split(iris, prop = 0.8)
iris_train <- training(iris_split)
iris_test <- testing(iris_split)

iris_recipe <- recipe(Species ~ ., data = iris_train) %>%
  step_center(all_predictors()) %>%
  step_scale(all_predictors())

iris_spec <- nearest_neighbor(weight_func = "rectangular", neighbors = 3) %>%
  set_engine("kknn") %>%
  set_mode("classification")


iris_workflow <- workflow() %>%
  add_recipe(iris_recipe) %>%
  add_model(iris_spec)

iris_fit <- fit(iris_workflow, data = iris_train) %>%
  last_fit(iris_split)

iris_fit %>%
  select(.predictions) %>%
  unnest(cols = c(.predictions))

iris_fit %>% collect_metrics()

iris_fit %>% collect_predictions()

iris_vetiver <- iris_fit %>%
  extract_workflow() %>%
  vetiver_model(model_name = "vetiver_iris")

board %>% vetiver_pin_write(iris_vetiver)


## Opcional, útil para ir adelantando step 4.


fs::dir_create( here::here("Taller/Step-3-vetiver/crear_docker_vetiver"))

vetiver_prepare_docker(board, name = "vetiver_iris", path = here::here("Taller/Step-3-vetiver/crear_docker_vetiver") )

vetiver_write_plumber(board, name = "vetiver_iris",  file = here::here("Taller/Step-3-vetiver/plumber.R") )
