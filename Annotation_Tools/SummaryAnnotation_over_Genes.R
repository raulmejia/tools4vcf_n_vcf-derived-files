#!/usr/bin/env Rscript
#  www.github.com/raulmejia
#  This file is free software: you may copy, redistribute and/or modify it  
#  under the terms of the GNU General Public License as published by the  
#  Free Software Foundation, either version 2 of the License, or (at your  
#  option) any later version.  
#  
#  This file is distributed in the hope that it will be useful, but  
#  WITHOUT ANY WARRANTY; without even the implied warranty of  
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU  
#  General Public License for more details.  
#  
#  You should have received a copy of the GNU General Public License  
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
suppressPackageStartupMessages(library("argparse"))

# create parser object
parser <- ArgumentParser()

# specify our desired options 
# by default ArgumentParser will add an help option 
parser$add_argument("-v", "--verbose", action="store_true", default=TRUE,
                    help="Print extra output [default]")
parser$add_argument("-q", "--quietly", action="store_false", 
                    dest="verbose", help="Print little output")
parser$add_argument("-i", "--inputfile", type="character", 
                    help="file with your gene list in  Entrez or ensembl ids")
parser$add_argument("-o", "--outputfile", type="character", 
                    help="file with your gene list in  Entrez or ensembl ids")
# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
args <- parser$parse_args()

# print some progress messages to stderr if "quietly" wasn't requested

myfile <-read.table(file=args$inputfile)
#myfile <-read.table(file="/media/rmejia/mountme88/Projects/Phosoholipidosis/Documents/trashmegenes.txt")
print( head( myfile ))
myfile[1,1]
str( myfile )
list_queries <- list()
for(k in 1:dim(myfile)[1]){
  list_queries[k] <- getGene(myfile[k,1], fields="all")
}

summaries <- list()
for(k in 1:length(list_queries)){ # making  a list that collect summarÿ́́s information'
  summaries[k] <- list_queries[[k]]$summary
  names(summaries)[k] <- list_queries[[k]]$symbol
}
retrivable <- data.frame( names(summaries) , as.character(summaries), stringsAsFactors = FALSE)


write.table(file=args$inputfile ,retrivable, row.names = FALSE, sep="\t")

