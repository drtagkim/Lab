#working
library(dplyr)
library(httr)
library(rvest)
library(stringr)
page <- read_html("sample.html",encoding='utf8')

page %>% html_node("container > div.contents > div.cont > div.tblTypeW > table") 
test=page %>% html_nodes("table")


test[[3]] %>% html_text() %>% cat()



