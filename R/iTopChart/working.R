library(rvest)
library(dplyr)
library(httr)
library(stringr)
library(purrr)

url="https://itopchart.com/gb/en/movies/"



gen_today <- function() {
  x=Sys.Date()
  as.character(x)
}

collect_items <- function(url_in) {
  page <- read_html(url_in)
  x1=page %>% html_node("div.list_items")
  title=x1 %>% html_nodes('div.item_box > div.item_info > a:nth-child(2)') %>% html_attr('title')
  ranking=x1 %>% html_nodes('div.item_box > ul.rank > li:nth-child(1)') %>% html_text()
  genre_price=x1 %>% html_nodes('div.item_box > ul.rank > li:nth-child(2)') %>% html_text()
  artist=x1 %>% html_nodes('div.item_box > div.artist') %>% html_text()
  region=parse_url(url)$path %>% str_split(fixed("/"),simplify = TRUE) %>% .[1,2]
  itunes=x1 %>% html_nodes('div.item_box > a.item_name') %>% html_attr("href")
  data.frame(ranking,title,genre_price,artist,region,itunes)
}

process_item <- function(dt) {
  dt<-dt %>%
    mutate(ranking=str_remove(ranking,fixed("No. "))) %>%
    mutate(genre=str_split(genre_price,regex("\\s.{1}[0-9\\.]+$"))%>%map_chr(~.[[1]])) %>%
    mutate(price=str_match(genre_price,regex(".{1}[0-9\\.]+$"))%>%map_chr(~.[[1]]) %>% coalesce('0')) %>%
    mutate(today=gen_today()) %>%
    select(-genre_price)
  dt
}


test<-collect_items(url)
test1<-process_item(test)
test1 %>% View('test')
