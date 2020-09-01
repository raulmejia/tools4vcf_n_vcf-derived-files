if (!require("biomaRt")) {
  BiocManager::install("biomaRt", dependencies = TRUE)
  library("biomaRt")
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
                    help="input file with your gene list in genesymbols")
parser$add_argument("-o", "--outputfile", type="character", 
                    help="output file where you want to store your results")
# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
args <- parser$parse_args()
# print some progress messages to stderr if "quietly" wasn't requested

#############################
## The program starts
#############################
myfile <-read.table(file=args$inputfile, stringsAsFactors = FALSE)
# myfile <-read.table(file="/home/rmejia/testgenesymbols.txt", stringsAsFactors = FALSE)

ensembl = useMart("ensembl")
ensembl = useMart(biomart="ensembl", dataset="hsapiens_gene_ensembl")

hgnc_symbol_list <- myfile[,1]
list_with_queries <- list()
for(k in 1:length(hgnc_symbol_list) ){
  biomresult <- biomaRt::getBM(attributes='ensembl_gene_id', 
                              filters = 'hgnc_symbol', 
                              values = hgnc_symbol_list[k], 
                              mart = ensembl)
  if(length(biomresult[,1]) == 0){
    list_with_queries[[k]] <- "NA"
  }
  if(length(biomresult[,1]) == 1){
    list_with_queries[[k]] <- biomresult[1,1]
  }
  
}

## Building the retrievable object
retrievable <- data.frame(hgnc_symbol_list , as.character(list_with_queries))
colnames(retrievable) = c("gene_symbols", "ensembl_ids")

###########################
#   Saving the results  ###
###########################
# path2save = "/home/rmejia/testgenesymbolsRESULTS.txt"
path2save <- args$outputfile
head(retrievable)
write.table(retrievable, file = paste0(path2save,"_table.tsv"), row.names = FALSE, sep="\t")

ensemblplain <- as.character(retrievable$ensembl_ids)
result_ensembl <- ensemblplain[!(ensemblplain == "NA")]
head(result_ensembl)
write.table(result_ensembl , file = path2save, row.names = FALSE, sep="\t" , col.names = FALSE, quote = FALSE)

# library(devtools)
# install_github("ropensci/rentrez")