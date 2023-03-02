# Load libraries
library(shiny)
library(tidyverse)

# Read in data
adult <- read_csv("adult.csv")
# Convert column names to lowercase for convenience 
names(adult) <- tolower(names(adult))

# Define server logic
shinyServer(function(input, output) {
  
  df_country <- reactive({
    adult %>% filter(native_country == input$country)
  })
  
  # TASK 5: Create logic to plot histogram or boxplot
  output$p1 <- renderPlot({
    if (input$graph_type == "histogram") {
      # Histogram
      ggplot(df_country(), aes_string(x = input$radio_continuous)) +
        geom_histogram(bins=50) +  # histogram geom
        labs (x="age", y = "Number of People", title = paste("Trend of ", input$radio_continuous)) + # labels
        facet_wrap(~prediction)    # facet by prediction
    }
    else {
      # Boxplot
      ggplot(df_country(), aes_string(y = input$radio_continuous)) +
        geom_boxplot() +  # boxplot geom
        coord_flip()+  # flip coordinates
        labs (x="age", y = "Number of People", title = paste("Trend of ", input$radio_continuous)) +  # labels
        facet_wrap(~prediction)    # facet by prediction
    }
    
  })
  
  # TASK 6: Create logic to plot faceted bar chart or stacked bar chart
  output$p2 <- renderPlot({
    # Bar chart
    p <- ggplot(df_country(), aes_string(x = input$radio_categorical)) +
      labs (x="age", y = "Number of People", title = paste("Trend of ", input$radio_categorical)) +  # labels
      theme_minimal()    # modify theme to change text angle and legend position
    
    if (input$is_stacked) {
      p + geom_bar(position="stacked") + fill = prediction  # add bar geom and use prediction as fill
    }
    else{
      p + geom_bar(position="dodge") + 
      fill = !!input$radio_categorical + # add bar geom and use input$categorical_variables as fill 
      facet_wrap(~prediction)   # facet by prediction
    }
  })
  
})
