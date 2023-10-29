
library(tidyverse)
library(brms)
library(tidybayes)
library(ggdist)
library(duckdb)
library(DBI)
library(logger)


log_info("Conectando a BD duckdb")
con <- dbConnect(duckdb(), dbdir = "/media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/my-db_2.duckdb", read_only = FALSE)

DBI::dbListTables(con)


log_info("Cargando modelo")

mod_reload <- readRDS("/media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/Taller/modelos/brms_model.rds")


# test de una BD local

log_info("Filtrando datos de hoy y prediciendo")
fecha_filter = "2023-10-31"

test_today <-  tbl(con, "test") %>%
  filter(fecha == fecha_filter)

print(test_today)
# estimacion puntual

log_info("Escribiendo predicción en la BD")
prediccion <-  predict(mod_reload, test_today, allow_new_levels = TRUE) %>%
  as.data.frame() %>%
  mutate(fecha = fecha_filter)

dbWriteTable(con, "prediccion", prediccion, append = TRUE)


preddb <-  tbl(con, "prediccion")
print(preddb)

dbDisconnect(con, shutdown = TRUE)


system2("notify-send", c("-i info", "-t 3600000",  "ACABÓ","'¡Chequea BD en /media/hd1/canadasreche@gmail.com/Jornadas_barcelona_2023/road-to-production/my-db_2.duckdb!!'", "-u critical"))



