library(shiny)
library(shinythemes)
library(ggplot2)
library(marsweather)

api_key = "AP643htGoOq3MVvE72ypY7B0Q5hsnfeln7ocXHWP"
mars_weather_url = paste0("https://api.nasa.gov/insight_weather/?api_key=", api_key, "&feedtype=json&ver=1.0")

result = get_data(mars_weather_url)
data = result$data
frame = transform_data(data)

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