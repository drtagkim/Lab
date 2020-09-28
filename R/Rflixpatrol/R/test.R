# #Exploratory Code
# library(rvest)
# library(dplyr)
# library(httr)
# library(stringr)
# library(purrr)
# URLROOT="https://flixpatrol.com"
#
#
# get_url_top10on <- function() {
#   page=read_html(URLROOT)
#   urls=page %>% html_node('[aria-labelledby="dropdownMenuLink1"]') %>% html_nodes('a') %>% html_attr('href')
#   address=paste(URLROOT,urls,sep='')
#   streamer=urls %>% str_split(fixed('/')) %>% map_chr(~.x[length(.x)])
#   tibble(streamer,address)
# }
#
# get_url_locales <- function() {
#   page=read_html(URLROOT)
#   urls=page %>% html_node('[aria-labelledby="dropdownMenuLink3"]') %>% html_nodes('a') %>% html_attr('href')
#   address=paste(URLROOT,urls,sep='')
#   streamer=urls %>% str_split(fixed('/')) %>% map_chr(~.x[length(.x)])
#   tibble(streamer,address)
# }
#
# streaming_sites <- get_url_top10on()
# streaming_locales <- get_url_locales()
#
# test <- read_chart(url.sample.3)
# read_stack_first(url.sample.4)
# read_stack_first(url.sample.5)
# read_stack_long(url.sample.6)
# read_stack_long(url.sample.7)
# read_stack_big(url.sample.8)
#
# # SAve --------------------------------------------------------------------
# #Data Update
# usethis::use_data(
#   url.sample.1
#   ,url.sample.2
#   ,url.sample.3
#   ,url.sample.4
#   ,url.sample.5
#   ,url.sample.6
#   ,url.sample.7
#   ,url.sample.8
#   ,streaming_sites
#   ,streaming_locales
#   ,internal = TRUE
#   ,overwrite = TRUE
# )
