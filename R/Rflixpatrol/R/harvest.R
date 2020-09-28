#harvest.R


read_chart <- function(url_in) {
  result=list()
  page <- read_html(url_in)
  test<-page %>% html_nodes(".row.rowhover div") %>% html_text() %>% str_trim()
  test.1<-matrix(test,ncol=9,byrow=TRUE)
  test.2<-data.frame(test.1[-1,])
  names(test.2)<-test.1[1,]
  test.2mv<-test.2[,-1]
  result$movie<-tibble(test.2mv)
  idx<-which(test.2[[1]]=="#")
  if(length(idx)>0) {
    test.2tv<-test.2[(idx+1):nrow(test.2),]
    names(test.2tv)<-test.1[1,]
    test.2tv<-test.2tv[,-1]
    result$tvshow<-tibble(test.2tv)
  }
  result
}
read_stack_first<-function(url_in) {
  page <- read_html(url_in)
  test<-page %>% html_nodes(".row.rowhover div") %>% html_text() %>% str_trim()
  test<-test[6:length(test)]
  test.1<-matrix(test,ncol=7,byrow=TRUE)
  test.1<-data.frame(test.1)
  test.1<-test.1%>% select(1:4) %>% as_tibble()
  names(test.1) <-c("rank",'title','release','points')
  test.1
}
read_stack_long <- function(url_in) {
  page <- read_html(url_in)
  test<-page %>% html_nodes(".row.rowhover div") %>% html_text() %>% str_trim()
  test<-test[5:length(test)]
  test.1<-matrix(test,ncol=6,byrow=TRUE)
  test.1<-data.frame(test.1)
  test.1<-test.1%>% select(1:3) %>% as_tibble()
  names(test.1) <-c("rank",'title','days1')
  test.1
}
read_stack_big <- function(url_in) {
  page <- read_html(url_in)
  test<-page %>% html_nodes(".row.rowhover div") %>% html_text() %>% str_trim()
  test<-test[7:length(test)]
  test.1<-matrix(test,ncol=9,byrow=TRUE)
  test.1<-data.frame(test.1)
  test.1<-test.1%>% select(1:5) %>% as_tibble()
  names(test.1) <-c("rank",'title','date','countries1','countries100')
  test.1
}
