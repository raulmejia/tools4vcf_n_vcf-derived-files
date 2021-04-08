######################
### Filter me
### This program receives a vcf-derived matrix and convert its contents to a matrix and then organize some relevant information within it in a columnar way
######################
## then I can do a program that could receive different amount of parameters
## Always defined by a triplet parameter, operator, value.
## 
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

##########################
###  Input given by the user
##########################
myargs <- commandArgs(trailingOnly = TRUE)

# path_your_vcf_derived_matrix <-"/media/rmejia/mountme88/Projects/Phosoholipidosis/Exome_Lipidosis/VCFs_Backup_to_work/Exact-Positions-match_DIL1_and_DIL2_and_Mom_A-FDad-as-bkgd.vcf"
path_your_vcf_derived_matrix <- myargs[1]

# code_path <- "/media/rmejia/mountme88/code/tools4vcf_n_vcf-derived-files/"
code_path <- myargs[2]

# Folder_to_save_Results <-"/media/rmejia/mountme88/Projects/Phosoholipidosis/Exome_Lipidosis/VCFs_Backup_to_work/Vcfderived-matrices_columnized-info"
Folder_to_save_Results <- myargs[3]

#your_label <- "Diagnoses"
#your_x_label <- myargs[8]

#######################
### Body
#######################
dir.create(Folder_to_save_Results, recursive = TRUE)
Folder_to_save_Results <- normalizePath( Folder_to_save_Results)

code_path <- normalizePath( code_path)
source(paste0(code_path,"/libraries/functions_to_columnize_vcf_derived_tables.R"))

# reading your vcf
# myvcf <- read.vcfR(path_your_vcf)

myCPRAtable <- read.table(path_your_vcf_derived_matrix, header = TRUE)
#head(myCPRAtable)

# Extracting the info and put it in a columnar way 
mytable_ExAC_columnized <- vcfderived_table_columnizing_ExAC( myCPRAtable )
mytable_g1000_columnized <- vcfderived_table_columnizing_g1000 (mytable_ExAC_columnized )
mytable_esp5400_columnized <- vcfderived_table_columnizing_esp5400(mytable_g1000_columnized )
mytable_type_of_var_columnized <- vcfderived_table_columnizing_type_of_var_by_transcription(   mytable_esp5400_columnized )
mytable_clinvar_columnized <- vcfderived_table_columnizing_clinvar( mytable_type_of_var_columnized )
mytable_nucleotid_change_columnized <- vcfderived_table_columnizing_nucleotid_change( mytable_clinvar_columnized)
mytable_Protein_change_columnized <- vcfderived_table_columnizing_protein_change( mytable_nucleotid_change_columnized )
mytable_dbSNP_columnized <- vcfderived_table_columnizing_dbSNP(mytable_Protein_change_columnized)
mytable_Polyphen2_columnized <- vcfderived_table_columnizing_Polyphen2( mytable_dbSNP_columnized )
mytable_GeneName_columnized <- vcfderived_table_columnizing_GeneName( mytable_Polyphen2_columnized  )

# head( mytable_GeneName_columnized , n = 50 )
# dim(mytable_GeneName_columnized)

### save it
path_2_savefile <- paste0( Folder_to_save_Results ,"/",basename( path_your_vcf_derived_matrix),"_table_derived_and_ExAC-g1000-esp5400-clinvar-type-NCh-PCh-dbSNP-Poly-Gen-columnized.tsv" )
write.table( mytable_GeneName_columnized , path_2_savefile , sep ="\t", row.names = FALSE)