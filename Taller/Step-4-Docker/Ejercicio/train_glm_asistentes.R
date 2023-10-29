library(tidyverse)

# Load data

path_data <-  "tu_directorio_datos"

path_data <-  here::here("Taller/R-ladder-to-production/Step-4-Docker/Ejercicio/data/")
train_path <-  str_glue(path_data, "train_to_glm.csv")
test_path <-  str_glue(path_data, "test_to_glm.csv")


(train <- read_csv(train_path) )
(test <- read_csv(test_path))

mod <- glm(cbind(Best, Other ) ~ tipo + valor_cliente + edad_cat,
           data = train, family = binomial)

summary(mod)

# plot opcional
sjPlot::plot_model(mod, transform = "plogis")

predict(mod, newdata = head(test), type = "response") %>%
  enframe()

# Salvar modleo en mismo directorio que el Dockerfile
saveRDS(mod, here::here("Taller/R-ladder-to-production/Step-4-Docker/Ejercicio/logistic_model.rds"))


