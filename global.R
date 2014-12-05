library(synapseClient)
library(plyr)
# library(mygene)
synapseLogin()

allresrdaFl <- synGet("syn2901303")
load(allresrdaFl@filePath)

# allresUniquerdaFl <- synGet("syn2901352")
# load(allresUniquerdaFl@filePath)

covariateNames <- names(allRes)
pairwiseNames <- llply(allRes, names)


# Requires mygene, which needs R >= 3.0
# # Use first set to get gene names
# ensembl <- data.frame(ensembl=rownames(allRes[["Gender"]][["Gender_female_male"]]))
# ensembl <- transform(ensembl, ensemblGeneId=gsub("\\..*", "", ensembl))
# 
# ensembl2symbol <- queryMany(ensembl$ensemblGeneId,
#                             scopes="ensemblgene", fields="symbol", species='human')

load("ensembl2symbol.RData")
