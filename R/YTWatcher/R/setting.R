# title: setting
# author: taekyung kim
# updated: 2021-10-25

# Libraries ---------------------------------------------------------------

library(tuber)
library(dplyr)
library(purrr)
library(yaml)
library(lubridate)
library(emayili)
library(rdrop2)
# Literal -----------------------------------------------------------------

emailconf <- yaml.load_file('email.yaml')
# Sources -----------------------------------------------------------------
source('R/functions.R')
