# Taekyung Kim, PhD. Associate Professor
# Kwangwoon University

# Library -----------------------------------------------------------------

suppressMessages({
  library(dplyr)
  library(rvest)
  library(httr)
  library(stringr)
  library(xlsx)
})

# Functions ---------------------------------------------------------------

get_url_path <- function(page) {
  URL <- "http://www.gsok.or.kr/certification-status-of-games-and-probability-information"
  modify_url(URL,query=list(pageid=page,mod='list'))
}
get_table_info <- function(url) {
  x=read_html(url)
  x1=x%>%html_node("div.kboard-list > table")
  id=x1 %>% html_nodes('tr > td.kboard-list-uid') %>% html_text() %>% trimws() %>% {.[2:length(.)]}
  if(is.na(id[1])) {
    return(NULL)
  }
  company_name=x1 %>% html_nodes('tr > td.kboard-list-company > div.kboard-default-cut-strings') %>% 
    html_text() %>% trimws() %>%
    str_match('^.+[\\t]') %>% str_trim()
  platform=x1 %>% html_nodes('tr > td.kboard-list-classification') %>% html_text() %>% trimws() %>% {.[2:length(.)]}
  game_name=x1 %>% html_nodes('tr > td.kboard-list-game > div') %>% html_text() %>% trimws() %>% {.[1:length(.)]}
  applied=x1 %>% html_nodes('tr > td:nth-child(5)') %>% html_text() %>% trimws() %>% {.[2:length(.)]}
  certified=x1 %>% html_nodes('tr > td:nth-child(6)') %>% html_text() %>% trimws() %>% {.[2:length(.)]}
  info_url=x1 %>% html_nodes('tr > td.kboard-list-detail > a') %>% html_attr('href') %>% trimws() %>% {.[1:length(.)]} %>%
    {paste('http://www.gsok.or.kr',.,sep='')}
  tibble(
    id,
    company_name,
    platform,
    game_name,
    applied,
    certified,
    info_url
  )
}


# Main --------------------------------------------------------------------

cat("\n\n\n====Lootbox Probability Public Bulletin====\n")
cat("   Taekyung Kim, PhD. Kwangwoon Univ.\n\n")

result_data=list()
cnt=1
while(TRUE) {
  cat(cnt,"...")
  url=get_url_path(cnt)
  item=get_table_info(url)
  if(is.null(item)) break
  result_data[[cnt]]=item
  cnt=cnt+1
  cat('OK.\n')
}
rm(url)
rm(item)
rm(cnt)
lootbox_public<-bind_rows(result_data)
rm(result_data)
fname=paste(as.character(Sys.Date()),'lootbox_public.xlsx',sep="_")
xlsx::write.xlsx(lootbox_public,fname)
rm(lootbox_public)
rm(fname,item)
cat("\n\nFile exported:",fname)
cat('\nBye.\n')

