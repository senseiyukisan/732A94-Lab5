library(jsonlite)
library(httr)


#' @title get_data
#' @description GET data from API endpoint
#' @param endpoint character
#' @return list()
#' @export 
get_data <- function(endpoint) {
  if (is.character(endpoint)) {
    response = GET(endpoint)
    json = content(response, as = "text")
    result = fromJSON(json)
    return (list("response"= response, "data"= result))
  }
  else {
    stop("endpoint needs to be of type character!")
  }
}

#' @title transform_data
#' @description transforms and filters data from JSON structure to table structure
#' @param data object
#' @return data.frame
#' @export
transform_data <- function(data) {
  temp_av <- c()
  temp_min <- c()
  temp_max <- c()
  
  ws_av <- c()
  ws_min <- c()
  ws_max <- c()
  
  press_av <- c()
  press_min <- c()
  press_max <- c()
  
  for (i in 1:length(data[["sol_keys"]])){
    temp_av[i] <- data[[data[["sol_keys"]][i]]][["AT"]][["av"]]
    temp_min[i] <- data[[data[["sol_keys"]][i]]][["AT"]][["mn"]]
    temp_max[i] <- data[[data[["sol_keys"]][i]]][["AT"]][["mx"]]
    
    ws_av[i] <- data[[data[["sol_keys"]][i]]][["HWS"]][["av"]]
    ws_min[i] <- data[[data[["sol_keys"]][i]]][["HWS"]][["mn"]]
    ws_max[i] <- data[[data[["sol_keys"]][i]]][["HWS"]][["mx"]]

    press_av[i] <- data[[data[["sol_keys"]][i]]][["PRE"]][["av"]]
    press_min[i] <- data[[data[["sol_keys"]][i]]][["PRE"]][["mn"]]
    press_max[i] <- data[[data[["sol_keys"]][i]]][["PRE"]][["mx"]]
  }
  frame <- data.frame("days" = data[["sol_keys"]], 
                      "av temp" = temp_av, 
                      "min temp" = temp_min, 
                      "max temp" = temp_max, 
                      "av wind" = ws_av, 
                      "min wind" = ws_min,
                      "max wind" = ws_max,
                      "av pres" = press_av,
                      "min pres" = press_min,
                      "max pres" = press_max
  ) 
}





