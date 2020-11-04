# Taekyung Kim 2020/10/30
# Test code
library(jsonlite)
library(dplyr)
library(purrr)
library(RSQLite)
library(DBI)

source('fun.R')

# -------------------------------------------------------------------------
# Modify here
OUTPUT='test' #output file name (prefix)

# -------------------------------------------------------------------------
# RUN

load('itunes_rss.RData')
objs=run_rss()
export_tsv(objs,OUTPUT)
rm(objs)
