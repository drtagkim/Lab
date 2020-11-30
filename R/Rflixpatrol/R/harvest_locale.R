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
  if("tvshow" %in% names(df)) {
    tvshow=df %>% map_dfr(~.x$tvshow)
    tvshow$Category="tvshow"
    rv=rbind(movie,tvshow)
  } else {
    rv=movie
  }
  rv$Stremaer=stream_site
  rv
}
collect_chart_locale_w <- function(k,datecode,locale,weeks=4,tout=120) {
  test.input=foreach(s=streaming_sites[[1]][2:11]) %do% {
    build_chart_code_w(datecode,weeks,locale=locale, site=s)
  }
  names(test.input)<-streaming_sites[[1]][2:11]
  inurls=test.input[[k]]
  rvs=list()
  rvs.names=build_week_codes(datecode,weeks)
  N=length(inurls)
  for(j in 1:N) {
    inurl=inurls[j]
    cat('[',j,'/',N,']',k,'|',rvs.names[j],'\n')
    suppressWarnings({
      rvs[[j]]=read_chart(inurl,rvs.names[j],tout)
    })
    Sys.sleep(10)
  }
  rvs
}
harvest_chart_locale_w <- function(df,stream_site,locale) {
  movie=df %>% map_dfr(~.x$movie)
  names(movie)[5]="PiCountry"
  names(movie)[7]="PiDay"
  names(movie)[9]="MovieLink"
  names(movie)[10]="Date"
  movie$Category="movie"
  if("tvshow" %in% names(df)) {
    tvshow=df %>% map_dfr(~.x$tvshow)
    names(tvshow)[5]="PiCountry"
    names(tvshow)[7]="PiDay"
    names(tvshow)[9]="MovieLink"
    names(tvshow)[10]="Date"
    tvshow$Category="tvshow"
    rv=rbind(movie,tvshow)
  } else {
    rv=movie
  }
  rv$Stremaer=stream_site
  rv$Points <- rv$Points %>% str_remove("\\s")
  rv$Total <- rv$Total %>% str_remove("\\s")
  rv$Change <- rv$Change %>% str_remove("\\s")
  rv$Locale=locale
  j=str_which(rv$Points,'^P')
  if(length(j)>0) {
    rv %>% slice(-j)
  } else {
    rv
  }
}
