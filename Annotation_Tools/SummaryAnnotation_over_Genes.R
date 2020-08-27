#!/usr/bin/env Rscript
# Copyright 2012-2013 Trevor L Davis <trevor.l.davis@gmail.com>
# Copyright 2008 Allen Day
#  
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
parser$add_argument("-i", "--input-file", type="character", 
                    help="file with your gene list in  Entrez or ensembl ids")
# get command line options, if help option encountered print help and exit,
# otherwise if options not found on command line then set defaults, 
args <- parser$parse_args()

# print some progress messages to stderr if "quietly" wasn't requested

myfile <-read.table(file= )
print(head( ))




if ( args$verbose ) { 
  write("writing some verbose output to standard error...\n", stderr()) 
}

# do some operations based on user input
if( args$generator == "rnorm") {
  
  cat(paste(rnorm(args$count, mean=args$mean, sd=args$sd), collapse="\n"))
} else {
  cat(paste(do.call(args$generator, list(args$count)), collapse="\n"))
}
cat("\n")