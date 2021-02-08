#codypriceanalytics.R
#version: 1.0.0
#kimtk@office.kw.ac.kr (Kwangwoon University, Associate Professor)
# util.R ------------------------------------------------------------------
reqPkg <- function(PKG) {
  REPO="https://cran.rstudio.com"
  suppressMessages({
    if(!require(PKG,character.only=TRUE,quietly=TRUE)) install.packages(PKG,repos=REPO,quiet=TRUE)
    require(PKG,character.only=TRUE,quietly=TRUE)
  })
}

source('codymongo.R')
source('codycompetitorapi.R')

price_analytics <- function(df,fun,...) {
  #df - cody_price_query_competitor()
  #fun - delegation
  reqPkg("dplyr")
  suppressMessages({
    df1<-df %>%
      group_by(hotel_id,target_date,code,groupingTitle) %>%
      summarize(price=mean(totalRate))%>%
      ungroup()
    fun(df1,...)  
  })
}
do_group_target_date <- function(df,...) {
  df %>%
    group_by(target_date)%>%
    summarize(price=mean(price))%>%
    ungroup()
}
do_group_target_date_code <- function(df,...) {
  df %>%
    group_by(target_date,code) %>%
    summarize(price=mean(price)) %>%
    ungroup()
}
do_group_target_date_fCode<-function(df,...) {
  #ellipsis - extra argument
  #.. ota - ota code
  ota=list(...)$ota #unlist argument
  df1<-df %>%
    filter(code==ota)
  do_group_target_date(df1,...)
}

plotLine <- function(df) {
  reqPkg("ggplot2")
  df %>% ggplot(aes(x=as.factor(target_date),y=price,group=1))+geom_line(color='red')+
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))
}
##
load_pms <- function(loc,pt) {
  #loc - directory
  fs=list.files(path=loc,pattern=pt,full.names = TRUE)
  for (f in fs) {
    print(f)
    load(f)
  }
}

#market price trend analysis
#Naver Hotel API
trend_analysis<-function(hotel_ids,td=NULL,db_name='marketprice01',today=NULL) {
  reqPkg('lubridate')
  if(is.null(td)) {
    td=as.character(ymd(Sys.Date())) #if null, set target dates from today
  }
  if(is.null(today)) {
    today=as.character(ymd(td)-1) #if null, set pin date as of yesterday
  }
  con <- cody_mongo("marketprice01")
  #cody_price_query_competitor() in codymongo.R
  q1<-cody_price_query_competitor(con,competitors=hotel_ids,td=td,today=today)
  disconnect_mongo(con)
  q1%>%
    group_by(arr_date=target_date) %>%
    summarize(price_max=max(totalRate),
              price_s1u=mean(totalRate)+sd(totalRate),
              price_mean=mean(totalRate),
              price_s1l=mean(totalRate)-sd(totalRate),
              price_min=min(totalRate)) %>%
    mutate(D=price_mean/price_mean[1]) %>%
    mutate(wday=as.character(wday(arr_date))) %>%
    ungroup()
}
plotPriceZone <- function(ta_output) {
  #trend_analysis output
  ta_output %>%
    select(arr_date,price_max,price_s1u,price_mean,price_s1l) %>%
    gather(price_max:price_s1l,key='g',value='p') %>%
    ggplot(aes(x=as.factor(arr_date),y=p,group=g,fill=g))+geom_area(color='white',size=0.8)+
    theme(axis.text.x=element_text(angle=90))
  
}
plotPriceZone2 <- function(ta_output) {
  #trend_analysis output
  ta_output %>%
    select(arr_date,price_max,price_s1u,price_mean,price_s1l) %>%
    ggplot(aes(x=as.factor(arr_date),y=price_mean,group=1))+
    geom_line()+
    geom_ribbon(aes(ymin=price_s1l,ymax=price_s1u),alpha=0.2,fill='skyblue')+
    theme(axis.text.x=element_text(angle=90))
}

#sub-function for get_
#dt-roomrate_item
base_price_regression <- function(dt) {
  m=lm(p~.,dt)
  nd=expand.grid(wday=as.character(1:7),
              room_typ_cd=unique(dt$room_typ_cd))
  r=predict(m,data.frame(nd))
  r=round(r/1000)*1000
  cbind(nd,r)
}
#dt-roomrate_item
get_base_price<-function(dt,fun,cdate='2020-12-13',hotel="nineetree-myungdong") {
  dt=dt %>%
    filter(hotel_id==hotel) %>%
    filter(arr_date<=cdate) %>%
    mutate(room_prc=as.numeric(room_prc)) %>%
    mutate(wday=as.character(wday(ymd(arr_date)))) %>%
    select(p=room_prc,wday,room_typ_cd)
  fun(dt)
}

cal_adr <- function(competitor_ids) {
  market_trend=competitor_ids %>% trend_analysis()
  pp=get_base_price(roomrate_items,base_price_regression)
  #test1=data.frame(wday=as.character(1:7),pp)
  result=market_trend %>% inner_join(pp)
  result%>%mutate(pps=r*D) #market interaction
}

validation_plot<-function(test) {
  hm=mean(test$pps)
  hsd=sd(test$pps)
  test %>%
    mutate(market_price=(price_mean-mean(price_mean))/sd(price_mean))%>%
    mutate(hotel_price=(pps-hm)/hsd)%>%
    select(arr_date,market_price,hotel_price) %>%
    gather(market_price,hotel_price,key='g',value='p') %>%
    ggplot(aes(x=as.factor(arr_date),y=p,group=g,color=g))+geom_line()+
    theme(axis.text.x=element_text(angle=90))
}
adr_plot <- function(test) {
  test %>%
    ggplot(aes(x=as.factor(arr_date),y=pps,group=1))+geom_line()+
    theme(axis.text.x=element_text(angle=90))
}


# roomrate_items%>%filter(hotel_id=='nineetree-myungdong') %>%
#   group_by(chk_date) %>% summarize(p=mean(as.numeric(room_prc)))%>%ungroup() %>% View('myungdong')

# Test --------------------------------------------------------------------
# test<-competitors[[1]] %>%
#   trend_analysis() %>%
#   plotPriceZone()
# competitors[[1]] %>%
#   trend_analysis() %>%
#   plotPriceZone2()

#


# #
# q3 <- price_analytics(q1,do_group_target_date)
# q4 <- price_analytics(q1,do_group_target_date_fCode,ota='AGD')
# q5 <- price_analytics(q1,do_group_target_date_code)
# 
# q5 %>%
#   ggplot(aes(x=as.factor(target_date),y=price,group=1))+geom_line(color='red')+
#   theme(axis.text.x=element_text(angle=90,vjust=0.5,hjust=1))+
#   facet_wrap(~code)

# plotLine(q4)




