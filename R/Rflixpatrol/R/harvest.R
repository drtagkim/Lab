#harvest.R


read_chart <- function(url_in,date_code,tout=20) {
  result=list()
  #url_in=url(url_in,'rb')
  page=url_in %>% GET(.,timeout(tout)) %>% read_html()
  #page=read_html(url_in,options='RECOVER')
  #close(url_in)
  rows=page %>% html_nodes(".row.rowhover div")
  movie_links=page %>% html_nodes(".row.rowhover a") %>% html_attr("href")
  movie_links=paste("https://flixpatrol.com",movie_links,sep="")
  test=rows %>% html_text() %>% str_trim()
  if(length(test)<=0) return(NULL)
  #
  test.1<-matrix(test,ncol=9,byrow=TRUE)
  test.2<-data.frame(test.1[-1,])
  idx<-which(test.2[[1]]=="#")
  #
  names(test.2)<-test.1[1,]
  result$movie<-tibble(test.2[1:(idx-1),])
  result$movie$movielink=movie_links[1:(idx-1)]
  result$movie$date=date_code
  result$movie[[1]]=NULL
  if(length(idx)>0) {
    test.2tv<-test.2[(idx+1):nrow(test.2),]
    names(test.2tv)<-test.1[1,]
    test.2tv<-test.2tv[,-1]
    result$tvshow<-tibble(test.2tv)
    result$tvshow$movielink=movie_links[(idx+1):nrow(test.2)]
    result$tvshow$date=date_code
  }
  result
}
collect_chart <- function(k,datecode,days=30) {
  test.input=foreach(s=streaming_sites[[1]][2:11]) %do% {
    build_chart_code(datecode,days,locale = 'world',site = s)
  }
  names(test.input)<-streaming_sites[[1]][2:11]
  inurls=test.input[[k]]
  rvs=list()
  rvs.names=build_date_codes(datecode,days)
  N=length(inurls)
  for(j in 1:N) {
    inurl=inurls[j]
    cat('[',j,'/',N,']',k,'|',rvs.names[j],'\n')
    rvs[[j]]=read_chart(inurl,rvs.names[j])
    Sys.sleep(10)
  }
  rvs
}
read_stack_first<-function(url_in) {
  page <- read_html(url_in)
  test<-page %>% html_nodes(".row.rowhover div") %>% html_text() %>% str_trim()
  if(length(test)<=0) return(NULL)
  #
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
  if(length(test)<=0) return(NULL)
  #
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
  if(legnth(test)<=0) return(NULL)
  #
  test<-test[7:length(test)]
  test.1<-matrix(test,ncol=9,byrow=TRUE)
  test.1<-data.frame(test.1)
  test.1<-test.1%>% select(1:5) %>% as_tibble()
  names(test.1) <-c("rank",'title','date','countries1','countries100')
  test.1
}
