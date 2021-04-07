#echo $1 $2 $3
# references https://samtools.github.io/bcftools/bcftools.html
###############################
## Data given by the user
###############################
reference_fasta=$1
father=$2
mother=$3
child=$4
output=$5

###############################
##### This script receives two VCF files and retrieves the intersection 
###################################
echo $reference_fasta $father $mother $child $output

samtools mpileup ‐B ‐q 1 ‐f $reference_fasta $father $mother $child > $output
#samtools mpileup ‐B ‐q 1 ‐f reference.fasta father.bam mother.bam child.bam > trio.mpileup



