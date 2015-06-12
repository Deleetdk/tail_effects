
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
      numericInput("size_A", "Blue group population size:", value =  1),
      numericInput("mean_B", "Red group mean:", value =  85),
      numericInput("sd_B", "Red group standard deviation:", value =  15),
      numericInput("size_B", "Red group population size:", value =  1),
      numericInput("threshold", "Threshold:", value =  130)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      p(a(href = "http://web.archive.org/web/20140826113234/http://blogs.discovermagazine.com/gnxp/2011/11/on-the-real-possibility-of-human-differences/", "Tail effects"),
        " are when there are large differences between groups at the extremes (tails) of distributions.",
      "This happens when the distributions differ in either the mean or the standard deviation (or both), even when these differences are quite small.",
      "Below we see a density plot of two normal distributions with different means as well as a threshold value (vertical line).",
      "The table below the plot shows various summary statistics about the distributions with regards to the threshold.",
      "Try playing around with the numbers on the left and see how results change."),
      plotOutput("plot"),
      dataTableOutput("table"),
      HTML("Made by <a href='http://emilkirkegaard.dk'>Emil O. W. Kirkegaard</a> using <a href='http://shiny.rstudio.com/'/>Shiny</a> for <a href='http://en.wikipedia.org/wiki/R_%28programming_language%29'>R</a>. Source code available <a href='https://github.com/Deleetdk/tail_effects'>on Github</a>.")
    )
  )
))
