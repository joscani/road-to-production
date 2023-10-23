library(tidyverse)
library(duckdb)

con <- dbConnect(duckdb(), dbdir = "my-db_2.duckdb", read_only = FALSE)


test <-  read_csv(here::here("data/test_local.csv"))
test$fecha <-  seq(as.Date("2023-10-22"), as.Date("2023-10-22") + 655, by = "day")


# write our prices data to duckdb table
duckdb::dbWriteTable(con, "test", test, overwrite = TRUE)
dbDisconnect(con, shutdown=TRUE)
