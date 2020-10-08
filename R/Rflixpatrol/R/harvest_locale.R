collect_chart_locale <- function(k,datecode,locale,days=30,tout=60) {
  test.input=foreach(s=streaming_sites[[1]][2:11]) %do% {
    build_chart_code(datecode,days,locale=locale, site=s)
  }
  names(test.input)<-streaming_sites[[1]][2:11]
  inurls=test.input[[k]]
  rvs=list()
  rvs.names=build_date_codes(datecode,days)
  N=length(inurls)
  for(j in 1:N) {
    inurl=inurls[j]
    cat('[',j,'/',N,']',k,'|',rvs.names[j],'\n')
    rvs[[j]]=read_chart_locale(inurl,rvs.names[j],locale,tout)
    Sys.sleep(10)
  }
  rvs
}
read_chart_locale <- function(url_in,date_code,locale,tout=60) {
  result=list()
  #url_in=url(url_in,'rb')
  page=url_in %>% GET(.,timeout(tout)) %>% read_html()
  #page=read_html(url_in,options='RECOVER')
  #close(url_in)
  #movie
  movie.rank=page %>% 
    html_nodes(xpath = '/html/body/div/div[2]/div/div[2]/div[2]/div/div[1]') %>% 
    html_text() %>% 
    str_remove(fixed(".")) %>%
    as.numeric()
  movie.title=page %>%
    html_nodes(xpath = '/html/body/div/div[2]/div/div[2]/div[2]/div/div[3]/a') %>% 
    html_text() %>% str_trim()
  movie.hyperlink=page %>%
    html_nodes(xpath = '/html/body/div/div[2]/div/div[2]/div[2]/div/div[3]/a') %>% 
    html_attr("href")
  movie.hyperlink = paste("https://flixpatrol.com",movie.hyperlink,sep='')
  movie<-tibble(Rank=movie.rank,
                Title=movie.title,
                Link=movie.hyperlink,
                Date=date_code,
                Locale=locale)
  result$movie=movie
  #tvshow
  tvshow.rank=page %>% 
    html_nodes(xpath = '/html/body/div/div[2]/div/div[2]/div[4]/div/div[1]') %>% 
    html_text() %>% 
    str_remove(fixed(".")) %>%
    as.numeric()
  tvshow.title=page %>%
    html_nodes(xpath = '/html/body/div/div[2]/div/div[2]/div[4]/div/div[3]/a') %>% 
    html_text() %>% str_trim()
  tvshow.hyperlink=page %>%
    html_nodes(xpath = '/html/body/div/div[2]/div/div[2]/div[4]/div/div[3]/a') %>% 
    html_attr("href")
  tvshow.hyperlink = paste("https://flixpatrol.com",tvshow.hyperlink,sep='')
  tvshow<-tibble(Rank=tvshow.rank,
                 Title=tvshow.title,
                 Link=tvshow.hyperlink,
                 Date=date_code,
                 Locale=locale)
  result$tvshow=tvshow
  result
}
harvest_chart_locale <- function(df,stream_site) {
  movie=df %>% map_dfr(~.x$movie)
  movie$Category="movie"
  tvshow=df %>% map_dfr(~.x$tvshow)
  tvshow$Category="tvshow"
  rv=rbind(movie,tvshow)
  rv$Stremaer=stream_site
  rv
}
