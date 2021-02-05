#################
## This script receives a VCF and retrieves a matrix derived VCF with a CPRA column added at the end
## The first argument should be the VCF, the second argument the result directory
## don't left blank spaces in the path for the results directory please!
## The input file should be separated by tab and double quotes separating fields "
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
addCP_2_a_matrix <- function( amatrix){
  amatrix_CP <- cbind( amatrix , paste0( amatrix[,"CHROM"] ,"-", amatrix[,"POS"]) ) ; colnames( amatrix_CP )[dim( amatrix_CP)[2]] <-"CP"
  return(amatrix_CP)
}

addCPR_2_a_matrix <- function( amatrix){
  amatrix_CPR <- cbind( amatrix_CP ,   paste0( amatrix_CP[,"CP"] ,"-",amatrix_CP[,"REF"] )  ) ; colnames( amatrix_CPR )[dim( amatrix_CPR)[2]] <-"CPR"
  return(amatrix_CPR)
}

addCPRA_2_a_matrix <- function( amatrix){
  amatrix_CPRA <- cbind( amatrix_CPR ,   paste0( amatrix_CPR[,"CP"] ,"-",amatrix_CPR[,"REF"],"-",amatrix_CPR[,"ALT"] )  ) ; colnames( amatrix_CPRA )[dim( amatrix_CPRA)[2]] <-"CPRA"
  return(amatrix_CPRA)
}

