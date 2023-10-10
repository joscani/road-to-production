library(brms)
library(plumber)
library(tidybayes)

library(future)
library(promises)

# future::plan(multisession, workers = 6)
future::plan(multicore, workers = 6, .cleanup = FALSE)

brms_model <- readRDS("brms_model.rds")
alive <<- TRUE

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

    data <- tryCatch(
      RcppSimdJson::fparse(req$postBody),
      error = function(e)
        NULL
    )
    if (is.null(data)) {
      res$status <- 400
      return(list(error = "No data submitted"))
    }

    res <- predict(brms_model, data) |>
      as.data.frame()
    Sys.sleep(10)
    return(res)
}


#* @post /predict_async
function(req, res) {


  promises::future_promise({
    data <- tryCatch(
      RcppSimdJson::fparse(req$postBody),
      error = function(e)
        NULL
    )
    if (is.null(data)) {
      res$status <- 400
      return(list(error = "No data submitted"))
    }

    res <- predict(brms_model, data) |>
      as.data.frame()
    Sys.sleep(10)
    return(res)
  })
}


#* @post /full_posterior
function(req, res) {
  promises::future_promise({
    data <- tryCatch(
    RcppSimdJson::fparse(req$postBody),
    error = function(e)
      NULL
  )
  if (is.null(data)) {
    res$status <- 400
    return(list(error = "No data submitted"))
  }

  add_epred_draws(data, brms_model)
  })

}

#* Health check. Returns "OK".
#* @serializer text
#* @get /health
function() {
  future({
    if (!alive) stop() else "OK"
  })
}
