
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Tail effects"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      helpText("Set the desired group values below."),
      numericInput("mean_A", "Blue group mean:", value =  100),
      numericInput("sd_A", "Blue group standard deviation:", value =  15),
      numericInput("mean_B", "Red group mean:", value =  85),
      numericInput("sd_B", "Red group standard deviation:", value =  15),
      numericInput("threshold", "Threshold:", value =  130)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("plot"),
      dataTableOutput("table")
    )
  )
))
