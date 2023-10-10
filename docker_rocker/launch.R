library(plumber)
pr <- plumber::plumb('/opt/ml/plumber.R')
pr$run(host = '0.0.0.0', port = 8080)
