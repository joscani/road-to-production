library(brms)
library(plumber)
library(tidybayes)

library(future)
library(promises)

future::plan(multicore, workers = 2, .cleanup = FALSE)

modelo <- readRDS("brms_model.rds") # aqui hay que cambiar brms_model.rds por el tuyo

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
    # esta es la parte que hay que cambiar, para que devuelva probabilidades del glm predict(modelo, newdata, type="response")
    res <- predict(modelo, data) |>
      as.data.frame()
    return(res)
  })
}


