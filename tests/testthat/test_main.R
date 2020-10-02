context("marsweather")

api_key = "AP643htGoOq3MVvE72ypY7B0Q5hsnfeln7ocXHWP"
mars_weather_url = paste0("https://api.nasa.gov/insight_weather/?api_key=", api_key, "&feedtype=json&ver=1.0")

test_that("Endpoint parameter needs to be of type character", {
  expect_error(get_data(12345))
})

test_that("Invalid API Key returns error", {
  invalid_api_key = "12345"
  endpoint_url_invalid_api_key = paste0("https://api.nasa.gov/insight_weather/?api_key=", invalid_api_key, "&feedtype=json&ver=1.0")
  expect_true(get_data(endpoint_url_invalid_api_key)[["response"]][["status_code"]] == 403)
})

test_that("Data is received", {
  expect_true(get_data(mars_weather_url)[["response"]][["status_code"]] == 200)
})

test_that("API limitations are counted correctly", {
  api_calls_remaining = as.integer(get_data(mars_weather_url)[["response"]][["headers"]][["x-ratelimit-remaining"]])
  expect_true(as.integer(get_data(mars_weather_url)[["response"]][["headers"]][["x-ratelimit-remaining"]]) == api_calls_remaining-1)
})

test_that("At least 7 data points are returned", {
  number_sol_keys = length(get_data(mars_weather_url)[["data"]][["sol_keys"]])
  expect_true(as.integer(number_sol_keys) >= 7)
  
})

test_that("All data points contain required fields", {
  sol_keys = get_data(mars_weather_url)[["data"]][["sol_keys"]]
  number_sol_keys = length(sol_keys)
  required_fields = c("AT", "HWS", "PRE")
  for (sol_key in 1:number_sol_keys) {
    expect_true(all(required_fields %in% names(data[[sol_keys[[sol_key]]]])))
  }
})

test_that(" 7 data points are returned", {
  number_sol_keys = length(get_data(mars_weather_url)[["data"]][["sol_keys"]])
  expect_true(as.integer(number_sol_keys) >= 7)
})


