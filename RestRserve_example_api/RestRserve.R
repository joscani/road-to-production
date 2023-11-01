library(brms)
library(tidybayes)
library(tidyverse)


library(RestRserve)

# importante poner esto en de midleware y demás
app <- Application$new(content_type="application/json", middleware=list())

brms_model <- readRDS("brms_model.rds")

app$add_get(
  path = "/health",
  FUN = function(.req, .res) {
    .res$set_body("OK")
  })


app$add_post(
  path = "/predict",
  FUN =
    function(.req, .res) {

      data <- tryCatch(jsonlite::fromJSON(rawToChar(.req$body)),
               error = function(e) NULL)
      if (is.null(data)) {
        .res$status <- 400
        return(list(error = "No data submitted"))

      }

      # data <- jsonlite::fromJSON(rawToChar(.req$body))

      result <- predict(brms_model, data, allow_new_levels = TRUE) %>%
        as.data.frame()
      Sys.sleep(30)
      # .res$set_content_type("application/json")
      .res$set_body(jsonlite::toJSON(result, auto_unbox=TRUE))
      .res$set_content_type("application/json")
    }
    )

backend = BackendRserve$new()
backend$start(app, http_port = 8080)


