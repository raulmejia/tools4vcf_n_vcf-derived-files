######################
### Filter me
### This program receives a vcf_derived_matrix with the parameters to use as filter organized in columns
######################
## Maybe I can do a program that could receive different amount of parameters, given by the user
## Always defined by a triplet parameter, operator, value.
## 
# Name of the Label in your vcf and 
# parameter to choose in label vcf 
##########################
### Installing and or Loading the required packages 
##########################
if (!require("argparse")) {
  install.packages("argparse", ask =FALSE)
  library("argparse")
}
if (!require("BiocManager")) {
  install.packages("BiocManager", ask =FALSE)
  library("BiocManager")
}
if (!require("tidyverse")) {
  install.packages("tidyverse", ask =FALSE)
  library("tidyverse")
}
if (!require("stringr")) {
  install.packages("stringr", ask =FALSE)
  library("stringr")
}
if (!require("ggplot2")) {
  install.packages("ggplot2", ask =FALSE)
  library("ggplot2")
}
if (!require("dplyr")) {
  install.packages("dplyr", ask =FALSE)
  library("dplyr")
}

#######################
### Functions defined by the user 
#######################
filter_AF_g1000_ExAC_esp5400 <- function(table_AF, maxAF){
  # This function keeps the NAs
  g1000discarded <- table_AF$g1000 > maxAF
  ExACdiscarded <- table_AF$ExAC > maxAF
  esp5400discarded <- table_AF$esp5400 > maxAF
  
  To_discard_by_allele_Frequency <- g1000discarded | ExACdiscarded | esp5400discarded
  To_discard_by_allele_Frequency[is.na(To_discard_by_allele_Frequency)] <- FALSE 
  
  mytable_filteredby_AF <- table_AF[!To_discard_by_allele_Frequency,]
  return( mytable_filteredby_AF )
}

##########################
###  Input given by the user
##########################
myargs <- commandArgs(trailingOnly = TRUE)

# path_your_table <-"/media/rmejia/mountme88/Projects/Phosoholipidosis/Exome_Lipidosis/VCFs_Backup_to_work/Vcfderived-matrices_columnized-info/Exact-Positions-match_DIL1_and_DIL2_and_Mom_A-FDad-as-bkgd.vcf_GTinfoDeleted__CPRAadded.tsv_table_derived_and_ExAC-g1000-esp5400-clinvar-type-NCh-PCh-dbSNP-Poly-Gen-columnized.tsv"
path_your_table <- myargs[1]

# code_path <- "/media/rmejia/mountme88/code/tools4vcf_n_vcf-derived-files/"
code_path <- myargs[2]

# Folder_to_save_Results <-"/media/rmejia/mountme88/Projects/Phosoholipidosis/Exome_Lipidosis/VCFs_Backup_to_work/Vcfderived-matrices_filtered"
Folder_to_save_Results <- myargs[3]

# AF_cutoff <- 0.06
AF_cutoff <- myargs[4]


#your_label <- "Diagnoses"
#your_x_label <- myargs[8]

#######################
### Body
#######################
dir.create(Folder_to_save_Results, recursive = TRUE)
Folder_to_save_Results <- normalizePath( Folder_to_save_Results)

code_path <- normalizePath( code_path)
source(paste0(code_path,"/libraries/functions_to_columnize_vcf_derived_tables.R"))

# reading your matrix
mytable <- read.table( path_your_table , header = TRUE)

mytable_AF_06 <- filter_AF_g1000_ExAC_esp5400( mytable , AF_cutoff ) # Filtering by AF

# Filtering by type of variant
mytable_type <- mytable %>% filter( Type_of_variant =='missense' | Type_of_variant=='nonsense'| Type_of_variant=='no-start'| Type_of_variant=='no-stop' | Type_of_variant=='inframe'| Type_of_variant=='frameshift ' | Type_of_variant=='5\'UTR'| Type_of_variant=='3\'UTR')

mytable_type_AF_06 <- filter_AF_g1000_ExAC_esp5400( mytable_type , AF_cutoff )

mytable_type_AF_06_No_UTRs <- mytable_type_AF_06 %>% filter( Type_of_variant !='5\'UTR' ) %>% filter( Type_of_variant !='3\'UTR' )

### save it
path_2_savefile <- paste0( Folder_to_save_Results ,"/", basename( path_your_table),"Type_of_var","AF_", AF_cutoff,"_including_UTR.tsv" )
write.table( mytable_type_AF_06  , path_2_savefile , sep ="\t", row.names = FALSE)

path_2_savefile <- paste0( Folder_to_save_Results ,"/", basename( path_your_table),"Type_of_var","AF_", AF_cutoff,"_No_UTR.tsv" )
write.table( mytable_type_AF_06_No_UTRs , path_2_savefile , sep ="\t", row.names = FALSE)
