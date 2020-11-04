
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


files=list.files('data1',full.names=TRUE)
dataset=list()
i=1
for(f in files) {
  cat(f,"\n")
  dataset[[i]]=run(f)
  i=i+1
}
write_database(dataset,'diva2018_2019.db')
#

files=list.files('data',full.names=TRUE)
dataset=list()
i=1
for(f in files) {
  cat(f,"\n")
  dataset[[i]]=run(f)
  i=i+1
}
write_database(dataset,'diva2018_2019.db')
