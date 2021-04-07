#################
## This script receives a folder that contain VCF files and retrieves a matrix that contains the condensed information
## the rownames of such a matrix could be CP (Chromosome and position) , CPR (CP and reference allele) 
## or CPRA (CPR plus alternative allele).
## The first argument should be the containing VCFs folder, the second argument the result directory
## Avoid blank spaces in your paths please!
## In the third argument you can choose wheter you prefer a CP, CPR or CPRA matrix
## the forth input is a label for your results
################
###################################
#### 0) loading and/or installing required libraries
###################################
if (!require("vcfR")) {
  install.packages("vcfR", dependencies = TRUE)
  library(vcfR)
}
if (!require("stringr")) {
  install.packages("stringr", dependencies = TRUE)
  library(stringr)
}

############################
## Defining funcions
#############################
addCP_2_a_matrix <- function( amatrix){
  amatrix_CP <- cbind( amatrix ,   paste0( amatrix[,"CHROM"],"-",amatrix[,"POS"] )  ) ; colnames( amatrix_CP )[dim( amatrix_CP)[2]] <-"CP"
  return(amatrix_CP)
}
#  funtion for CPR and CPRA

############################
#### Data given by the user
#############################
args <- commandArgs(trailingOnly = TRUE)
inputvcfsfolder_path <- args[1]
inputvcfsfolder_path <- "/media/rmejia/mountme88/LAMP2seq/LAMP2_seq2_outputs/2020_12_29_RunNumber_LAMP2Projekt_82_374/VariantCaller/TSVC_variants_IonXpress_002-ID-KL_007.vcf.gz"

inputvcfsfolder_path <- "/media/rmejia/mountme88/LAMP2seq/LAMP2_seq2_outputs/2020_12_29_RunNumber_LAMP2Projekt_82_374/VariantCaller/"
inputvcfsfolder_path <- "/media/rmejia/mountme88/LAMP2seq/LAMP2_seq2_outputs/toy/"
result_path <- args[2]
#result_path <- "/home/rmejia/Downloads/toy"

result_path <- "/media/rmejia/mountme88/LAMP2seq/LAMP2_seq2_outputs/toy/CPmatrix.tsv"

pattern_2_delete <- "TSVC_variants_IonXpress_"

##############################
# The script begins
##############################
your_vcfbasenames_paths <- system(paste0("ls ",inputvcfsfolder_path) , intern = TRUE) # getting the files that include "vcf" in their name
only_vcfbasenames_paths <- your_vcfbasenames_paths[grepl("vcf",your_vcfbasenames_paths)]
only_vcfbasenames_notbi_paths <- only_vcfbasenames_paths[!grepl("tbi", only_vcfbasenames_paths)] # erasing the tbi files

names4cols <- lapply( only_vcfbasenames_notbi_paths , function(x){ str_remove(x,pattern_2_delete)}) # trimming the files' names
names4cols <- unlist(names4cols) # colnames for the final matrix

# reading the vcfs
vcfabsolute_paths <- paste0( inputvcfsfolder_path , only_vcfbasenames_notbi_paths) # getting the absolute paths of the vcf files to be readed
vcf_list <- list() 
for( k in 1:length( vcfabsolute_paths) ) {
  vcf_list[[k]] <- read.vcfR( vcfabsolute_paths[k] ) # reading the vcf s and loading to a list object
}
names(vcf_list) <- names4cols

# extracting the info but the genotype information
vcffix_list <- list()
vcffix_list <- lapply(vcf_list, function(x){ return(x@fix)}) # extracting the info but the genotype info


vcffixCP_list <- lapply( vcffix_list , addCP_2_a_matrix ) # adding the CP to the matrix

vcffix_onlyCP_list <- lapply(vcffixCP_list, function(x){return(x[,"CP"])} ) # extraction only the CP

rownamesunion <- unique (unlist(vcffix_onlyCP_list) ) 


number_of_cells <- rep( 0, length(rownamesunion)* length(names4cols ) )
resultmatrix <- matrix( number_of_cells , ncol =  length( names4cols ) ) 
colnames(resultmatrix) <- names4cols
rownames( resultmatrix) <- sort(rownamesunion)


#k = "003-ID-KL_010.vcf.gz"

for( k in names(vcffix_onlyCP_list) ){ 
  for(w in 1:length(as.character(vcffix_onlyCP_list[[k]])) ){
    resultmatrix[as.character(vcffix_onlyCP_list[[k]])[w],k] <-  1
    print(k)
    print(w)
  }
}

result_path <- normalizePath(result_path)
#dir.create(result_path ,recursive = TRUE) ## create result dir if it doesn't exist

write.table(resultmatrix, file=result_path, quote = FALSE, sep = "\t")

heatmap(resultmatrix, scale="none",  margins = c(10,5))
?heatmap

pdf(file = "/media/rmejia/mountme88/LAMP2seq/LAMP2_seq2_outputs/toy/CPmatrix.pdf", height = 17, width = 14)
heatmap(resultmatrix, scale="none",  margins = c(10,5), cexRow = 0.6)
dev.off()

?heatmap
heatmap(resultmatrix, scale="none", Rowv = NA, margins = c(10,5))
heatmap(t(resultmatrix) , scale="none", Rowv = NA, margins = c(5,9))
heatmap(t(resultmatrix) , scale="none", Rowv = NA, Colv =NA, margins = c(5,9))

dim(resultmatrix)
?heatmap

signature<-c("119577854","119577856","119585109","119585121","119588789","119597785","119599187","119600706","119600707","119600708")
#signature<-c("119577854","119577856","119585109","119585121","119588789","119597785","119599187","119600706","119600707","119600708"
             ,"119568477","119568858")

sort(rownamesunion)

rownamesunion[which(rownamesunion %in% paste0("chrX-",signature))]

resultmatrix[which(rownamesunion %in% paste0("chrX-",signature)),]



sum(resultmatrix["chrX-119577854",])
sum(resultmatrix["chrX-119577856",])
sum(resultmatrix["chrX-119585109",])
sum(resultmatrix["chrX-119585121",])

#sum(resultmatrix["chrX-119588789",])

sum(resultmatrix["chrX-119597785",])
sum(resultmatrix["chrX-119599187",])
sum(resultmatrix["chrX-119600706",])
sum(resultmatrix["chrX-119600707",])

sum(resultmatrix["chrX-119600708",])


resultmatrix[,"014-ID-HIPSC_154.vcf.gz"]

