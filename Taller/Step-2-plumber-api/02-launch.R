# ejecutar en segundo plano, otra sesión de R etc..

library(plumber)
pr <- plumber::plumb(here::here("Taller/Step-2-plumber-api/01-plumber_async.R"))
pr$run(host = '0.0.0.0', port = 8000)
