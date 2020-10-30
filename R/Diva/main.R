
# Library -----------------------------------------------------------------

library(dplyr)
library(httr)
library(rvest)
library(stringr)
library(RSQLite)
library(DBI)
library(foreach)

source("fun.R")
# Main --------------------------------------------------------------------


files=list.files('data',full.names=TRUE)
dataset=foreach(f=files) %do% run(f)
write_database(dataset,'test.db')
