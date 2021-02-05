#################
## This script receives a VCF and retrieves a matrix derived VCF with a CP column added at the end
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
  amatrix_CP <- cbind( amatrix ,   paste0( amatrix[,"CHROM"],"-",amatrix[,"POS"] )  ) ; colnames( amatrix_CP )[dim( amatrix_CP)[2]] <-"CP"
  return(amatrix_CP)
}

############################
#### Data given by the user
#############################
args <- commandArgs(trailingOnly = TRUE)
inputvcf_path <- args[1]
inputvcf_path <- "/media/rmejia/mountme88/LAMP2seq/LAMP2_seq2_outputs/2020_12_29_RunNumber_LAMP2Projekt_82_374/VariantCaller/TSVC_variants_IonXpress_002-ID-KL_007.vcf.gz"
result_path <- args[2]
result_path <- "/home/rmejia/Downloads/toy"

##############################
# The script begins
##############################
result_path <- normalizePath(result_path)
dir.create(result_path ,recursive = TRUE) ## create result dir if it doesn't exist

myvcf <- read.vcfR( inputvcf_path ) ### read
vcf_matrix <- myvcf@fix ## Extract all the data but the GT
vcf_matrix_CP <- addCP_2_a_matrix(vcf_matrix) ## 

path_2_savefile <- paste0(result_path,"/",basename(inputvcf_path),"_matrix_GTinfoDeleted_CPadded.tsv" )

write.table(file=path_2_savefile , vcf_matrix_CP, sep="\t",row.names = FALSE )

