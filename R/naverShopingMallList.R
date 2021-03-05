library(chromote)
library(rvest)
library(stringr)

b=ChromoteSession$new() #new session
b$Page$navigate("https://search.shopping.naver.com/mall/mall.nhn")
b$view()
#
pageChange <- function(b,i) {
  code=sprintf("mall.changePage(%d,'listPaging')",i)
  b$Runtime$evaluate(code)
  NULL
}

extract_table <- function(i) {
  pageChange(b,i)
  page_source=b$Runtime$evaluate('document.querySelector("#mall_area > div.malltv_lst > table").outerHTML')
  page_source=page_source$result$value
  page=read_html(page_source)
  get_link<-function(page) {
    page %>% 
      html_nodes("td.url") %>% 
      html_text() #link
  }
  get_product_count<-function(page) {
    page %>% 
      html_nodes("td.item") %>% 
      html_text() %>% str_trim() %>% 
      str_remove_all(",") %>% 
      as.numeric()
  }
  get_product_grade<-function(page) {
    page %>% 
      html_nodes("td.mall_grade") %>% 
      html_text() %>% 
      str_trim()
  }
  tibble(page_id=i,
         shoppingmallurl=get_link(page),
         productcount=get_product_count(page),
         grade=get_product_grade(page))
}


output=list()
for(i in 1:564) {
  cat(i,'of 563\n')
  output[[i]]=extract_table(i)
  Sys.sleep(1)
}
fashion_category=bind_rows(output)
save(fashion_category,file=file.choose())
write.csv(fashion_category,file.choose(),row.names=F)
