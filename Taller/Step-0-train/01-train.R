library(tidyverse)
library(brms)
library(cmdstanr)
library(tidybayes)
library(ggdist)

options(mc.cores = parallel::detectCores()-1)

# Load data

train <- read_csv(here::here("Taller/data/train_local.csv"))
train <- train %>%
  mutate(target1 = as_factor(ifelse(segmento == "Best", "Best", "Other")))

head(train)
glimpse(train)

formula <- brmsformula(
  target1| resp_weights(n)  ~ (1 | edad_cat) + (1 | valor_cliente) + (1 | tipo)
)

mod <- brm(
  formula,
  family = "bernoulli", data = train,
  iter = 4000, warmup = 1000, cores = 4,
  chains = 4,
  seed = 10,
  backend = "cmdstanr",
  refresh = 100) # refresh 0 qu eno quiero que se me llene el post de los output de las cadenas mcm

summary(mod)
fixef(mod)
ranef(mod)

prior_summary(mod)


brms::stancode(mod)
#
# mod$data <- train
saveRDS(mod, here::here("Taller/modelos/brms_model.rds"))


mod_reload <- readRDS( here::here("Taller/modelos/brms_model.rds"))


summary(mod_reload)
fixef(mod_reload)
ranef(mod_reload)

prior_summary(mod_reload)

brms::stancode(mod_reload)

lobstr::obj_size(mod_reload)


#

test <-  read_csv(here::here("Taller/data/test_local.csv"))

# estimacion puntual
predict(mod_reload, head(test), allow_new_levels = TRUE)


posterior_pred <- add_epred_draws(test[1:8, ], mod_reload)
dim(posterior_pred)

head(posterior_pred )

posterior_pred %>%
  ggplot(aes(x = .epred, y = as_factor(.row))) +
  ggdist::stat_halfeye()


## modelo 2 con interacciones


formula <- brmsformula(
  target1| resp_weights(n)  ~ (1 | edad_cat) + (1 | valor_cliente) + (1 | edad_cat : valor_cliente)  + (1 | tipo)
)

mod2 <- brm(
  formula,
  family = "bernoulli", data = train,
  iter = 4000, warmup = 1000, cores = 4,
  chains = 4,
  seed = 10,
  backend = "cmdstanr",
  refresh = 100) # refresh 0 qu eno quiero que se me llene el post de los output de las cadenas mcm

summary(mod2)
fixef(mod2)
ranef(mod2)

prior_summary(mod2)

# mod$data <- train
saveRDS(mod2, here::here("Taller/modelos/brms_model_interactions.rds"))


mod2_reload <- readRDS( here::here("Taller/modelos/brms_model_interactions.rds"))

