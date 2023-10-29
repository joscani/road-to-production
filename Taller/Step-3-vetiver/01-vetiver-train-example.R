library(vetiver)
library(tidymodels)
library(pins)
library(plumber)



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

board <- board_folder(here::here("Taller/modelos/modelo_vetiver/"), versioned = TRUE)
board %>% vetiver_pin_write(iris_vetiver)


## Opcional, útil para ir adelantando step 4.


fs::dir_create( here::here("Taller/Step-3-vetiver/crear_docker_vetiver"))

vetiver_prepare_docker(board, name = "vetiver_iris", path = here::here("Taller/Step-3-vetiver/crear_docker_vetiver") )

vetiver_write_plumber(board, name = "vetiver_iris",  file = here::here("Taller/Step-3-vetiver/plumber.R") )
