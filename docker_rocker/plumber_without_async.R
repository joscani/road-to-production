library(brms)
library(plumber)
library(tidybayes)

brms_model <- readRDS("brms_model.rds")


#* @apiTitle brms predict Api
#* @apiDescription Endpoints for working with brms model

## ---- filter-logger
#* Log some information about the incoming request
#* @filter logger
function(req){
  cat(as.character(Sys.time()), "-",
      req$REQUEST_METHOD, req$PATH_INFO, "-",
      req$HTTP_USER_AGENT, "@", req$REMOTE_ADDR, "\n")
  forward()
}

## ---- post-data
#* Submit data and get a prediction in return
#* @post /predict
function(req, res) {
  data <- tryCatch(jsonlite::parse_json(req$postBody, simplifyVector = TRUE),
                   error = function(e) NULL)
  if (is.null(data)) {
    res$status <- 400
    return(list(error = "No data submitted"))
  }

  predict(brms_model, data, allow_new_levels = TRUE) |>
    as.data.frame()
}


#* @post /full_posterior
function(req, res) {
  data <- tryCatch(jsonlite::parse_json(req$postBody, simplifyVector = TRUE),
                   error = function(e) NULL)
  if (is.null(data)) {
    res$status <- 400
    return(list(error = "No data submitted"))
  }

  add_epred_draws(data, brms_model)

}
