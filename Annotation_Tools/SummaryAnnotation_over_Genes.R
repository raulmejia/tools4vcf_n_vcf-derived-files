#!/usr/bin/env Rscript
#  www.github.com/raulmejia
####################
### Explanation ####
####################
# This script receives a file with Entrez ids as rows and retrieves a data frame including their summaries

#########################
#### Load libraries #####
#########################
if (!require("mygene")) {
  BiocManager::install("mygene", dependencies = TRUE)
  library("mygene")
}
suppressPackageStartupMessages(library("argparse"))

############################## 
## Data given by the user
##############################
# create parser object
parser <- ArgumentParser()

# specify our desired options 
# by default ArgumentParser will add an help option 
parser$add_argument("-v", "--verbose", action="store_true", default=TRUE,
                    help="Print extra output [default]")
parser$add_argument("-q", "--quietly", action="store_false", 
                    dest="verbose", help="Print little output")
parser$add_argument("-i", "--inputfile", type="character", 
                    help="input file with your gene list in  Entrez or ensembl ids")
parser$add_argument("-o", "--outputfile", type="character", 
                    help="output file where you want to store your results")
# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
args <- parser$parse_args()
# print some progress messages to stderr if "quietly" wasn't requested

#############################
## The program starts
#############################
myfile <-read.table(file=args$inputfile)
#myfile <-read.table(file="/media/rmejia/mountme88/Projects/Phosoholipidosis/Documents/trashmegenes.txt")

list_queries <- list()
for(k in 1:dim(myfile)[1]){
  list_queries[k] <- mygene::getGene(myfile[k,1], fields="all")
}

summaries <- list()
for(k in 1:length(list_queries)){ # making  a list that collect summarÿ́́s information'
  summaries[k] <- list_queries[[k]]$summary
  names(summaries)[k] <- list_queries[[k]]$symbol
}
# Contructing the retrievable object
retrivable <- data.frame( myfile[,1], names(summaries) , as.character(summaries), stringsAsFactors = FALSE)
names(retrivable) = c("ids","genesymbol","summary")

write.table(file=args$outputfile ,retrivable, row.names = FALSE, sep="\t")

