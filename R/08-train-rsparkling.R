
# doc https://s3.amazonaws.com/h2o-release/sparkling-water/spark-3.2/3.42.0.3-1-3.2/doc/rsparkling.html

library(tidyverse)
library(sparklyr)
library(rsparkling)
library(h2o)
# h2o.init()

packageVersion("h2o")
packageVersion("rsparkling")

sc <-  spark_connect(master = "local",
                     spark_home = "/home/jose/spark/spark-3.2.0-bin-hadoop2.7/")

h2oConf <- H2OConf()
h2oConf$setBasePort(55555)
h2oConf$set("spark.ext.h2o.cloud.name", "mycloud")

hc <- H2OContext.getOrCreate(h2oConf)




# Load data

train <- read_csv(here::here("data/train_local.csv"))
train <- train %>%
  mutate(target1 = as_factor(ifelse(segmento == "Best", "Best", "Other")))

train_spark <-  sc %>% sdf_copy_to(train)
train_hex <- hc$asH2OFrame(train_spark)

y = "target1"
x = c("tipo", "valor_cliente", "edad_cat")

train_hex[, "target1"] <- as.factor(train_hex[, "target1"])

mod <- h2o.xgboost(
  x = x,
  y = y ,
  training_frame = train_hex,
  weights_column = "n",
  distribution = "bernoulli",

)

summary(mod)
h2o.varimp_plot(mod)

fs::dir_create(here::here("modelos/modelo_mojo"))
h2o.download_mojo(mod, path = here::here("modelos/modelo_mojo"))
