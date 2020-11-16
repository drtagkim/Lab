#harvest.R


read_chart <- function(url_in,date_code,tout=60) {
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
    result$tvshow$movielink=movie_links[idx:length(movie_links)]
    result$tvshow$date=date_code
  }
  result
}

collect_chart <- function(k,datecode,days=30,tout=120,weekly=FALSE) {
  test.input=foreach(s=streaming_sites[[1]][2:11]) %do% {
    build_chart_code(datecode,days,locale='world', site=s,weekly=weekly)
  }
  names(test.input)<-streaming_sites[[1]][2:11]
  inurls=test.input[[k]]
  rvs=list()
  rvs.names=build_date_codes(datecode,days)
  N=length(inurls)
  for(j in 1:N) {
    inurl=inurls[j]
    cat('[',j,'/',N,']',k,'|',rvs.names[j],'\n')
    rvs[[j]]=read_chart(inurl,rvs.names[j],tout)
    Sys.sleep(10)
  }
  rvs
}

harvest_chart <- function(df,stream_site) {
  movie=df %>% map_dfr(~.x$movie)
  names(movie)[5]="PiCountry"
  names(movie)[7]="PiDay"
  names(movie)[9]="MovieLink"
  names(movie)[10]="Date"
  movie$Category="movie"
  tvshow=df %>% map_dfr(~.x$tvshow)
  names(tvshow)[5]="PiCountry"
  names(tvshow)[7]="PiDay"
  names(tvshow)[9]="MovieLink"
  names(tvshow)[10]="Date"
  tvshow$Category="tvshow"
  rv=rbind(movie,tvshow)
  rv$Stremaer=stream_site
  rv$Points <- rv$Points %>% str_remove("\\s")
  rv$Total <- rv$Total %>% str_remove("\\s")
  rv$Change <- rv$Change %>% str_remove("\\s")
  rv
}

