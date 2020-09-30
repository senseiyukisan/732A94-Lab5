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



