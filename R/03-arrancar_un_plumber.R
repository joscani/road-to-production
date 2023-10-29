
# en rstudio como background jobs in source
library(plumber)
pr(here::here("R/02-ejemplo_plumber.R")) |>
  pr_run(port=8000)

## usando callr para tener un subproceso de R corriendo

in_bg_plumb <- callr::r_bg(function(){
  library(plumber)
  pr(here::here("R/02-ejemplo_plumber.R")) |>
    pr_run(port=8000)})

in_bg_plumb$get_pid()


system(stringr::str_glue("kill {in_bg_plumb$get_pid()}"))



in_bg_plumb <- callr::r_bg(function(){
  library(plumber)
  pr(here::here("Taller/R-ladder-to-production/Step-4-Docker/docker_rocker/plumber_async.R")) |>
    pr_run(port=8000)})

in_bg_plumb$get_pid()


system(stringr::str_glue("killall {in_bg_plumb$get_pid()}"))
