
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("PCBC DESeq2 results, all samples"),
  
  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      
      htmlOutput("selectCovariate"),
      htmlOutput("selectPairwise"),
            
      sliderInput("pval", label=h3("Adjusted p-value threshold"),
                  min=0, max=0.25, value=0.01, step=0.01, width=500),

      sliderInput("minmeancount", label=h3("Minimum mean count"),
                  min=0, max=500, value=0, step=5, width=500),
      
      sliderInput("ntopgenes", label = h3("# of top genes"),
                  min = 0, max = 5000, value = 100, step=20, width=500)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      downloadButton('downloadtable','Download table'),
      htmlOutput("topgene_linkOut"),
      tableOutput("table")
    )
  )
))
