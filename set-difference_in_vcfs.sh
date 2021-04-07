###########################
### Description
###########################
# this script takes two vcfs and retrieves the difference of the first one (eliminating the elements that belong to the intersection and the elements that belong only to the second one)
# Note the flexibility of the vcf-isec tool: " Given multiple VCF files, it can output the list of positions which are shared by at least N files, at most N files, exactly N files, etc. "  https://vcftools.github.io/perl_module.html#vcf-isec
#


# 

# outputs positions present in the files A but absent from files B and C. 
vcf-isec -c A.vcf.gz B.vcf.gz C.vcf.gz | bgzip -c > out.vcf.gz

