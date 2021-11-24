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

# Literal -----------------------------------------------------------------
literal <- yaml::read_yaml('literal.yaml')
emailconf <- yaml.load_file('email.yaml')
# Sources -----------------------------------------------------------------
source('r/functions.R')
