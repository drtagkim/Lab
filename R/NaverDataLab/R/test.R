collect_card_index <- function() {
  page=clipr::read_clip() %>% paste(collapse = '') %>% read_html()
  code.tooltip<-'.graph_tooltip'
  root_node=page %>% html_node(code.tooltip)
  ym=root_node%>% html_node(".tooltip_period") %>% html_text()
  info=root_node%>% html_nodes('.tooltip .info') %>% html_text()
  value=root_node%>% html_nodes('.tooltip .value') %>% html_text() %>% as.numeric()
  tibble(
    ym,
    info,
    value
  )
}

run_collect_card_data <- function(city,sex,age) {
  dt<-list()
  cnt=1
  icode=readline("ENTER TO GO(q=END)")
  while(icode!='q') {
    icode=readline(paste("[",cnt,"]>"))
    dt[[cnt]]=collect_card_index()
    cnt=cnt+1

  }
  dt=bind_rows(dt)
  dt$city=city
  dt$sex=sex
  dt$age=age
  dt
}
