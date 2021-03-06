
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com


shinyServer(function(input, output) {
  
  reac_data = reactive({
    #make dataframe
    d = data.frame(matrix(ncol = 3, nrow = 1000))
    colnames(d) = c("A_den", "B_den", "x")
    #find lower x limit
    lowest.group.mean = min(input$mean_A, input$mean_B)
    which.lowest = which.min(c(input$mean_A, input$mean_B))
    if (input$mean_A > input$mean_B) {
      lowest.group.SD = input$sd_B
    } else {
      lowest.group.SD = input$sd_A
    }
    plot.lower.limit = min(lowest.group.mean - (lowest.group.SD * 3), input$threshold)
    #find upper x limit
    highest.group.mean = max(input$mean_A, input$mean_B)
    which.highest = which.max(c(input$mean_A, input$mean_B))
    if (input$mean_A > input$mean_B) {
      highest.group.SD = input$sd_A
    } else {
      highest.group.SD = input$sd_B
    }
    plot.upper.limit = max(highest.group.mean + (highest.group.SD * 3), input$threshold)
    #calculate x steps
    d$x = seq(plot.lower.limit, plot.upper.limit, length.out = 1000)
    #calculate densities
    d$A.den = dnorm(d$x, mean = input$mean_A, sd = input$sd_A) * input$size_A
    d$B.den = dnorm(d$x, mean = input$mean_B, sd = input$sd_B) * input$size_B
    #return
    return(d)
  })

  output$plot <- renderPlot({
    #plot
    w = 1.5
    ggplot(reac_data(), aes(x = x)) +
      geom_line(aes(x = x, y = A.den), color = "blue", size = w) +
      geom_line(aes(x = x, y = B.den), color = "red", size = w) +
      geom_vline(xintercept = input$threshold, linetype = "dashed", size = w, alpha = .7) +
      xlab("Trait level") + ylab("Density")

  })
  
  output$table = renderDataTable({
    t = data.frame(matrix(nrow = 4, ncol = 4))
    colnames(t) = c("Blue Group", "Red group", "Ratio blue/red", "Percent blue")
    rownames(t) = c("Percent above threshold",
                   "Percent below threshold",
                   "Mean of population above threshold",
                   "Mean of population below threshold")
    ## insert values
    #percent above
    t[1, 1] = (1 - pnorm(input$threshold, mean = input$mean_A, sd = input$sd_A)) * 100
    t[1, 2] = (1 - pnorm(input$threshold, mean = input$mean_B, sd = input$sd_B)) * 100
    #percent below
    t[2, 1] = pnorm(input$threshold, mean = input$mean_A, sd = input$sd_A) * 100
    t[2, 2] = pnorm(input$threshold, mean = input$mean_B, sd = input$sd_B) * 100
    #ratio
    t[1, 3] = (t[1, 1] * input$size_A) / (t[1, 2] * input$size_B)
    t[2, 3] = (t[2, 1] * input$size_A) / (t[2, 2] * input$size_B)
    ## means of subgroups
    d = reac_data() #fetch data
    d.above = d[d$x > input$threshold, ]
    d.below = d[d$x < input$threshold, ]
    #above
    t[3, 1] = weighted.mean(d.above$x, d.above$A.den)
    t[3, 2] = weighted.mean(d.above$x, d.above$B.den)
    #below
    t[4, 1] = weighted.mean(d.below$x, d.below$A.den)
    t[4, 2] = weighted.mean(d.below$x, d.below$B.den)
    #Percent blue
    t[1, 4] = (t[1, 1] * input$size_A / (t[1, 1] * input$size_A + t[1, 2] * input$size_B)) * 100
    t[2, 4] = (t[2, 1] * input$size_A / (t[2, 1] * input$size_A + t[2, 2] * input$size_B)) * 100
    
    #render and return
    t = DT::datatable(t, options = list(dom = 't'))
    return(t)
  })

})
