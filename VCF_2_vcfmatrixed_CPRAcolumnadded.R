#################
## This script receives a VCF and retrieves a matrix derived VCF with a CPRA column added at the end
## The first argument should be the VCF, the second argument the result directory
## don't left blank spaces in the path for the results directory please! 
################
###################################
#### 0) loading and/or installing required libraries
###################################

if (!require("vcfR")) {
  install.packages("vcfR", dependencies = TRUE)
  library(vcfR)
}

############################
## Defining funcions
#############################
addCPRA_2_a_matrix <- function( amatrix){
  amatrix_CP <- cbind( amatrix , paste0( amatrix[,"CHROM"] ,"-", amatrix[,"POS"]) ) ; colnames( amatrix_CP )[dim( amatrix_CP)[2]] <-"CP"
  amatrix_CPR <- cbind( amatrix_CP ,   paste0( amatrix_CP[,"CP"] ,"-",amatrix_CP[,"REF"] )  ) ; colnames( amatrix_CPR )[dim( amatrix_CPR)[2]] <-"CPR"
  amatrix_CPRA <- cbind( amatrix_CPR ,   paste0( amatrix_CPR[,"CP"] ,"-",amatrix_CPR[,"REF"],"-",amatrix_CPR[,"ALT"] )  ) ; colnames( amatrix_CPRA )[dim( amatrix_CPRA)[2]] <-"CPRA"
  return(amatrix_CPRA)
}

############################
#### Data given by the user
#############################
args <- commandArgs(trailingOnly = TRUE)
inputvcf <- args[1]

result_path <- args[2]

##############################
# The script begins
##############################

dir.create(result_path ,recursive = TRUE) ## create result dir if it doesn't exist
result_path <- normalizePath(result_path)

myvcf <- read.vcfR( inputvcf) ### read
vcf_matrix <- myvcf@fix ## Extract all the data but the GT
vcf_matrix_CPRA <- addCPRA_2_a_matrix(vcf_matrix) ## 

path_2_savefile <- paste0(result_path,"/",basename(inputvcf),"_GTinfoDeleted__CPRAadded.tsv" )

write.table(file=path_2_savefile , vcf_matrix_CPRA, sep="\t",row.names = FALSE )
