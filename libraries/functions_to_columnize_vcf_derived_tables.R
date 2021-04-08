
vcfderived_table_columnizing_ExAC  <- function( some_vcfderived_table ){
  ExACcolumn <-  unlist ( lapply( some_vcfderived_table[,"INFO"] , function(x) str_extract(x, "ExAC:[0-9]+\\.[0-9]+" ) ) ) 
  ExACcolumn <- as.numeric(str_replace_all( ExACcolumn, "ExAC:",""))
  some_vcfderived_table_p_ExAC <- cbind( some_vcfderived_table, ExACcolumn ) ;  names(some_vcfderived_table_p_ExAC)[ dim(some_vcfderived_table_p_ExAC)[2] ] <- "ExAC"
  return( some_vcfderived_table_p_ExAC )
}

vcfderived_table_columnizing_g1000  <- function( some_vcfderived_table ){
  g1000column <-  unlist ( lapply( some_vcfderived_table[,"INFO"] , function(x) str_extract(x, "g1000:[0-9]+\\.[0-9]+" ) ) ) 
  g1000column <- as.numeric(str_replace_all( g1000column, "g1000:",""))
  some_vcfderived_table_p_g1000 <- cbind( some_vcfderived_table, g1000column ) ;  names(some_vcfderived_table_p_g1000)[ dim(some_vcfderived_table_p_g1000)[2] ] <- "g1000"
  return( some_vcfderived_table_p_g1000 )
}

vcfderived_table_columnizing_type_of_var_by_transcription  <- function( some_vcfderived_table ){
  splice_donor_pos <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "[:alnum:]+[:punct:][:alnum:]+[:punct:]\\+[:alnum:]+;SF" ) ) )
  AllbutUTRs_pos <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "[:alnum:]+;SF" ) ) ) 
  UTRs_pos <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "[:alnum:]+[:punct:][:alnum:]+;SF" ) ) ) 
  
  tp_of_var <- splice_donor_pos 
  tp_of_var[is.na(tp_of_var)] <- UTRs_pos[is.na(tp_of_var)]
  tp_of_var[is.na(tp_of_var)] <- AllbutUTRs_pos[is.na(tp_of_var)]
  tp_of_var_clean <- str_replace_all( tp_of_var, ";SF","" )
  
  some_vcfderived_table_p_tp_of_var <- 
    cbind( some_vcfderived_table, tp_of_var_clean) ;  names( some_vcfderived_table_p_tp_of_var )[ dim( some_vcfderived_table_p_tp_of_var )[2] ] <- "Type_of_variant"
  return( some_vcfderived_table_p_tp_of_var )
}

vcfderived_table_columnizing_esp5400  <- function( some_vcfderived_table ){
  esp5400column <-  unlist ( lapply( some_vcfderived_table[,"INFO"] , function(x) str_extract(x, "esp5400:[0-9]+\\.[0-9]+" ) ) ) 
  esp5400column <- as.numeric(str_replace_all( esp5400column , "esp5400:",""))
  some_vcfderived_table_p_esp5400 <- 
    cbind( some_vcfderived_table, esp5400column ) ;  names(  some_vcfderived_table_p_esp5400 )[ dim(  some_vcfderived_table_p_esp5400 )[2] ] <- "esp5400"
  return(  some_vcfderived_table_p_esp5400 )
}

vcfderived_table_columnizing_clinvar  <- function( some_vcfderived_table ){
  clinvar_col <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "clinvar:[:alnum:]+" ) ) )
  clinvar_no_etiquette <- str_replace_all( clinvar_col, "clinvar:","" )
  some_vcfderived_table_p_clinvar <- 
    cbind( some_vcfderived_table, clinvar_no_etiquette) ;  names( some_vcfderived_table_p_clinvar )[ dim( some_vcfderived_table_p_clinvar )[2] ] <- "clinvar"
  return( some_vcfderived_table_p_clinvar )
}

vcfderived_table_columnizing_nucleotid_change  <- function( some_vcfderived_table ){
  Nucleotid_change <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "\\|c\\.[:graph:]+>[:alnum:]+\\|" ) ) )
  Nucleotid_clean <- str_replace_all( Nucleotid_change  , "\\|","" )
  some_vcfderived_table_p_Nucleotidchange <- 
    cbind(  some_vcfderived_table , Nucleotid_clean ) ;  names( some_vcfderived_table_p_Nucleotidchange )[ dim( some_vcfderived_table_p_Nucleotidchange )[2] ] <- "Nucleotid_change"
  return( some_vcfderived_table_p_Nucleotidchange )
}

vcfderived_table_columnizing_protein_change  <- function( some_vcfderived_table ){
  Protein_change <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "p\\.:\\(p\\.[:alnum:]+\\)" ) ) )
  some_vcfderived_table_p_Proteinchange <- 
    cbind(  some_vcfderived_table , Protein_change ) ;  names( some_vcfderived_table_p_Proteinchange )[ dim( some_vcfderived_table_p_Proteinchange )[2] ] <- "Protein_change"
  return( some_vcfderived_table_p_Proteinchange )
}

vcfderived_table_columnizing_dbSNP  <- function( some_vcfderived_table ){
  dbSNP_col <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "DBXREF=dbSNP:[:alnum:]+" ) ) )
  dbSNP_col_no_etiquette <- str_replace_all( dbSNP_col, "DBXREF=dbSNP:","" )
  some_vcfderived_table_p_dbSNP <- 
    cbind( some_vcfderived_table, dbSNP_col_no_etiquette) ;  names( some_vcfderived_table_p_dbSNP )[ dim(some_vcfderived_table_p_dbSNP )[2] ] <- "dbSNP"
  return( some_vcfderived_table_p_dbSNP )
}

vcfderived_table_columnizing_Polyphen2  <- function( some_vcfderived_table ){
  Polyphen2column <-  unlist ( lapply( some_vcfderived_table[,"INFO"] , function(x) str_extract(x, "PolyPhen2:[0-9]+\\.[0-9]+" ) ) ) 
  Polyphen2column <- as.numeric(str_replace_all( Polyphen2column, "PolyPhen2:",""))
  some_vcfderived_table_p_Polyphen2 <- 
    cbind( some_vcfderived_table, Polyphen2column ) ;  names(some_vcfderived_table_p_Polyphen2)[ dim(some_vcfderived_table_p_Polyphen2)[2] ] <- "Polyphen2"
  return( some_vcfderived_table_p_Polyphen2 )
}

vcfderived_table_columnizing_GeneName  <- function( some_vcfderived_table ){
  GeneName_Column <- unlist ( lapply( some_vcfderived_table [,"INFO"] , function(x) str_extract(x, "SGVEP=[:alnum:]+" ) ) )
  GeneName_Column <- str_replace_all( GeneName_Column  , "SGVEP=","" )
  some_vcfderived_table_p_GeneName <- 
    cbind(  some_vcfderived_table , GeneName_Column ) ;  names( some_vcfderived_table_p_GeneName )[ dim( some_vcfderived_table_p_GeneName )[2] ] <- "Gene"
  return( some_vcfderived_table_p_GeneName )
}
