library(jsonlite)
library(shiny)
library(shinythemes)
library(ggplot2)


api_key = "AP643htGoOq3MVvE72ypY7B0Q5hsnfeln7ocXHWP"
mars_weather_url = paste0("https://api.nasa.gov/insight_weather/?api_key=", api_key, "&feedtype=json&ver=1.0")


get_data <- function(endpoint) {
  response <- fromJSON(endpoint)
}

data = get_data(mars_weather_url)
temp_av <- c()
temp_min <- c()
temp_max <- c()

ws_av <- c()
ws_min <- c()
ws_max <- c()
# ws_dir <- c()

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

ui <- fluidPage(
  theme = shinytheme("lumen"),
  titlePanel("Mars Weather"),
  sidebarLayout(
    sidebarPanel(
      
      # Select type of trend to plot
      selectInput(inputId = "selected", label = strong("Select"),
                  choices = c("Temperature" = "temp",
                              "Windspeed" = "wind",
                              "Pressure" = "pres"),
                  selected = "Temperature")
    ),
    
    # Output: Description, lineplot, and reference
    mainPanel(
      plotOutput(outputId = "lineplot", height = "300px"),
      textOutput(outputId = "desc"),
      tags$a(href = "https://api.nasa.gov/assets/insight/InSight%20Weather%20API%20Documentation.pdf", "Source: NASA API", target = "_blank")
    )
  )
)

# Define server function
server <- function(input, output) {
  output$lineplot <- renderPlot({
    # ggplot(y_fin, aes(x= frame[["days"]], group = 1), size = 1.5) +
    ggplot(frame, aes(x=days, group = input$selected)) +
      geom_line(aes(y = .data[[paste0("av.", input$selected)]], x=days, colour = "green")) +
      geom_line(aes(y = .data[[paste0("min.", input$selected)]], x=days, colour="blue")) +
      geom_line(aes(y = .data[[paste0("max.", input$selected)]], x=days, colour="red"))+
      scale_color_manual(name = input$selected, labels = c("minimum", "average", "maximum"), values = c("blue","green","red"))+
      ylab(input$selected)+
      xlab("Sol days")
    })
}


# Create Shiny object
shinyApp(ui = ui, server = server)

