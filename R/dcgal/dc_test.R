library(tidyverse, quietly = TRUE)
library(rvest, quietly = TRUE)
library(httr,quietly = TRUE)
library(foreach,quietly = TRUE)

# -------------------------------------------------------------------------

DCURL="https://gall.dcinside.com"

# -------------------------------------------------------------------------
build_dc_url_by_page <- function(inURL,end_page_id=100) {
  #value-NULL or URL in character
  all_URL=foreach(i=1:end_page_id,.combine=c) %do% {
    x=parse_url(inURL)
    x$query$page=i
    build_url(x)
  }
  if(length(all_URL)>0) {
    return(all_URL)
  }
  NULL
}

create_page <- function(url.in) {
  page <- read_html(url.in)
  t1<-page %>% html_node("table:first-child")
  t1
}

extract_data_page <- function(nd) {
  doc_id <- function(nd) {
    nd %>% html_nodes("td.gall_num") %>% html_text() %>% stringr::str_trim() %>% stringr::str_match("^[0-9]+")
  }
  doc_title <- function(nd) {
    nd %>% html_nodes("td.gall_tit") %>% html_text() %>% stringr::str_trim() %>% stringr::str_remove_all("\\r|\\n|\\t")
  }
  doc_url <- function(nd) {
    nd %>% html_nodes("td.gall_tit a:first-child") %>% html_attr('href')
  }
  doc_writer <- function(nd) {
    nd %>% html_nodes("td.gall_writer") %>% html_text() %>% stringr::str_trim() %>% stringr::str_remove_all("\\r|\\n|\\t") %>% stringr::str_remove_all("\\(.+\\)")
  }
  doc_date <- function(nd) {
    nd %>% html_nodes("td.gall_date") %>% html_attr("title")
  }
  doc_count <- function(nd) {
    nd %>% html_nodes("td.gall_count") %>% html_text() %>% stringr::str_remove_all(",|-") %>% as.numeric()
  }
  doc_recommend <- function(td) {
    nd %>% html_nodes("td.gall_recommend") %>% html_text() %>% stringr::str_remove_all(",|-") %>% as.numeric()
  }
  x=tibble(
    id=doc_id(nd),
    title=doc_title(nd),
    url=doc_url(nd),
    writer=doc_writer(nd),
    date=doc_date(nd),
    count=doc_count(nd),
    recommend=doc_recommend(nd)
  )
  x=na.omit(x)
  x=x %>% mutate(url=paste(DCURL,url,sep=""))
  x
}
# -------------------------------------------------------------------------

# -------------------------------------------------------------------------

inURL="https://gall.dcinside.com/board/lists/?id=seouluniversity"
inURL2="https://m.dcinside.com/board/sogang"
all_url = inURL %>% build_dc_url_by_page(2304)
##error prone
##
result=foreach(u=all_url,i=1:length(all_url),.combine=bind_rows) %do% {
  cat("page:",i,"\n")
  x=create_page(u) %>% extract_data_page()
  x=cbind(page_id=i,x)
}
