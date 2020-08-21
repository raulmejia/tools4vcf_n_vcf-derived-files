# Comparing by CPRA , CPR & CP 
#################
## This script receives two matrix with CPRA columns (matrix derived from VCFs)
## As arguments to matrices with CPRA info, if it is possible the first one should contain the annotations
# the third argument will be the folder for the results
# And the fourth a "label" for the results file
## As a result tree intersected files
## don't left blank spaces in the path for the results directory please! 
################
###################################
#### 0) loading and/or installing required libraries
###################################

############################
## Defining funcions
#############################

############################
#### Data given by the user
#############################
args <- commandArgs(trailingOnly = TRUE)

mat1anot_path <- args[1]

mat2_path <- args[2]

result_path <- args[3]

label <- args[4]

                                        
##############################
# The script begins
##############################

dir.create(result_path ,recursive = TRUE) ## create result dir if it doesn't exist
result_path <- normalizePath(result_path)

mat1anot <- read.table(mat1anot_path, header=T, sep="\t") ### read
mat2 <- read.table(mat2_path, header=T, sep="\t") ### read

# CPRA
CPRA_inter_pos <- which(mat1anot[,"CPRA"] %in% mat2[,"CPRA"] ) ; CPRA_inter <-mat1anot[CPRA_inter_pos,]
path_2_interfile_CPRA <- paste0(result_path,"/",label,"_CPRA_intersect.tsv" )
write.table(file=path_2_interfile_CPRA , CPRA_inter, sep="\t",row.names = FALSE )

# CPR
CPR_inter_pos <- which(mat1anot[,"CPR"] %in% mat2[,"CPR"] ) ; CPR_inter<-mat1anot[CPR_inter_pos,]
path_2_interfile_CPR <- paste0(result_path,"/",label,"_CPR_intersect.tsv" )
write.table(file=path_2_interfile_CPR , CPR_inter, sep="\t",row.names = FALSE )

# CP
CP_inter_pos <- which(mat1anot[,"CP"] %in% mat2[,"CP"] ) ; CP_inter<-mat1anot[CP_inter_pos,]
path_2_interfile_CP <- paste0(result_path,"/",label,"_CP_intersect.tsv" )
write.table(file=path_2_interfile_CP , CP_inter, sep="\t",row.names = FALSE )

