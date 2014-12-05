
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {

  output$selectCovariate <- renderUI({ 
    selectInput("Covariate", "Select a covariate", choices=covariateNames,
                selected="Cell_Type_of_Origin", width=500)
  })

  output$selectPairwise <- renderUI({ 
    covariate <- input$Covariate
    selectInput("Pairwise", "Select a pairwise comparison", choices=pairwiseNames[[covariate]],
                selected=pairwiseNames[[covariate]][1], width=500)
  })
  
  output$table <- renderTable({ 
    res <- allRes[[input$Covariate]][[input$Pairwise]]
    res <- res[order(res$padj), ]
    res <- subset(res, padj < input$pval & baseMean > input$minmeancount)
    
    res <- res[1:input$ntopgenes, ]

    res <- as.data.frame(res)
    res$Ensembl <- gsub("\\..*", "", rownames(res))
        
    res <- merge(res, ensembl2symbol, by.x="Ensembl", by.y="query", all.x=TRUE)
    
    as.data.frame(res[, c("symbol", "Ensembl", "baseMean", "log2FoldChange", "pvalue", "padj")])
  })
  
  
})
