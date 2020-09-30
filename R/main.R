library(httr)

api_key = "AP643htGoOq3MVvE72ypY7B0Q5hsnfeln7ocXHWP"
mars_weather_url = paste0("https://api.nasa.gov/insight_weather/?api_key=", api_key, "&feedtype=json&ver=1.0")


get_data <- function(endpoint) {
  response <- GET(endpoint)
}

data = get_data(mars_weather_url)



