library(jsonlite)
library(shiny)
library(shinythemes)


api_key = "AP643htGoOq3MVvE72ypY7B0Q5hsnfeln7ocXHWP"
mars_weather_url = paste0("https://api.nasa.gov/insight_weather/?api_key=", api_key, "&feedtype=json&ver=1.0")


get_data <- function(endpoint) {
  response <- fromJSON(endpoint)
}

data = get_data(mars_weather_url)

ui <- fluidPage(
  theme = shinytheme("lumen"),
  titlePanel("Mars Weather"),
  sidebarLayout(
    sidebarPanel(
      
      # Select type of trend to plot
      selectInput(inputId = "type", label = strong("Select"),
                  choices = unique(trend_data$type),
                  selected = "Temperature")
      )
    ),
    
    # Output: Description, lineplot, and reference
    mainPanel(
      plotOutput(outputId = "lineplot", height = "300px"),
      textOutput(outputId = "desc"),
      tags$a(href = "https://api.nasa.gov/assets/insight/InSight%20Weather%20API%20Documentation.pdf", "Source: NASA API", target = "_blank")
    )
)



server <- function(input, output) {
    # data[["648"]][["AT"]][["av"]]
    temp_av <- c()
    temp_min <- c()
    temp_max <- c()
    
    ws_av <- c()
    ws_min <- c()
    ws_max <- c()
    ws_dir <- c()
    
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
      # ws_dir <- c()
      
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
  
# Histogram of the Old Faithful Geyser Data ----
# with requested number of bins
# This expression that generates a histogram is wrapped in a call
# to renderPlot to indicate that:
#
# 1. It is "reactive" and therefore should be automatically
#    re-executed when inputs (input$bins) change
# 2. Its output type is a plot
output$lineplot <- renderPlot({
  
  x    <- faithful$waiting
  bins <- seq(min(x), max(x), length.out = input$bins + 1)
  
  hist(x, breaks = bins, col = "#75AADB", border = "white",
       xlab = "Waiting time to next eruption (in mins)",
       main = "Histogram of waiting times")
})
}



