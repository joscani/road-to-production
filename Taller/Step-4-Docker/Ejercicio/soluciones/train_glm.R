library(tidyverse)



# Load data

path_data <-  "tu_directorio_datos"

path_data <-  here::here("Taller/R-ladder-to-production/Step-4-Docker/Ejercicio/data/")
train_path <-  str_glue(path_data, "train_local.csv")
test_path <-  str_glue(path_data, "test_local.csv")


train <- read_csv(train_path)

train <- train %>%  mutate(target1 = as_factor(ifelse(segmento == "Best", "Best", "Other")))


train_to_glm <- train %>%
  group_by(tipo, valor_cliente, edad_cat, target1) %>%
  summarise(n = sum(n)) %>%
  pivot_wider(id_cols = tipo:edad_cat,
              names_from = target1,
              values_from = n) %>%
  replace(is.na(.), 0)

write_csv(train_to_glm, file= str_glue(here::here(path_data), "train_to_glm.csv"))


test <- read_csv(test_path)

test_to_glm <- test %>%
  distinct(tipo, valor_cliente, edad_cat)

write_csv(test_to_glm, file= str_glue(here::here(path_data), "test_to_glm.csv"))

mod <- glm(cbind(Best, Other ) ~ tipo + valor_cliente + edad_cat,
           data = train_to_glm, family = binomial)



predict(mod, newdata = head(test_to_glm), type = "response")

#
# mod$data <- train
saveRDS(mod, here::here("Taller/R-ladder-to-production/Step-4-Docker/Ejercicio/logistic_model.rds"))


