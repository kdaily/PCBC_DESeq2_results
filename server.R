
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

    # Sort by p-value
    res <- subset(res, !is.na(padj))
    res <- droplevels(res)
        
    res <- subset(res, padj < input$pval & baseMean > input$minmeancount)
    res <- droplevels(res)

    res <- res[1:min(input$ntopgenes, nrow(res)), ]
    res <- as.data.frame(res)
    
    res$Ensembl <- gsub("\\..*", "", rownames(res))
        
    res <- merge(res, ensembl2symbol, by.x="Ensembl", by.y="query", all.x=TRUE)
    
    res <- res[order(res$padj), ]
    
    results$table <- as.data.frame(res)[, c("symbol", "Ensembl", "baseMean", "log2FoldChange", "pvalue", "padj")]
    results$table
    
  }, digits=4, include.rownames=FALSE)
  
  # Store current results
  results <- reactiveValues() 
  
  #prepare data for download
  output$downloadtable <- downloadHandler(
    filename = function() {
      paste('results.csv')
    },
    content  = function(file){
      write.csv(results$table, file=file, row.names=F, col.names=T)      
    })
  
  output$topgene_linkOut <- reactive({
    prefix <- '<form action="https://toppgene.cchmc.org/CheckInput.action" method="post" target="_blank" display="inline">\
    <input type="hidden" name="query" value="TOPPFUN">\
    <input type="hidden" id="type" name="type" value="HGNC">\
    <input type="hidden" name="training_set" id="training_set" value="%s">\
    <input type="Submit" class="btn shiny-download-link" value="Enrichment Analysis in ToppGene">\
    </form>'

    
    geneIds <- unique(results$table$symbol)
    geneIds  <- geneIds[geneIds != ""]
    geneIds <- paste(geneIds, collapse=" ")
    
    #generate the HTML content
    htmlContent <- sprintf(prefix, geneIds)
    htmlContent
  })
  
  
})
