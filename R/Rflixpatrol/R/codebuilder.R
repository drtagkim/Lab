#code_builder
build_date_codes <- function(start_date,rollback_days,include_today=TRUE) {
  dates=lubridate::date(start_date)-(ifelse(include_today,0,1):rollback_days)
  as.character(dates)
}
build_week_codes <- function(start_date,rollback_weeks,include_this_week=TRUE) {
  d1=lubridate::ymd(start_date)
  y=lubridate::year(d1)
  if(include_this_week) {
    d2=d1-weeks(0:(rollback_weeks-1))

  } else {
    d2=d1-weeks(1:rollback_weeks)
  }
  d2=lubridate::week(d2)
  d3=sprintf("%d-%03d",y,d2)
  as.character(d3)
}

build_chart_code <- function(start_date,rollback_days,locale='world',site="netflix",include_today=TRUE) {
 url_base="https://flixpatrol.com/top10"
 dates=build_date_codes(start_date,rollback_days,include_today)
 url_code=paste(url_base,site,locale,dates,'full',sep='/')
 url_code
}

build_chart_code_w <- function(start_date,rollback_weeks,locale='world',site="netflix",include_this_week=TRUE) {
  url_base="https://flixpatrol.com/top10"
  dates=build_week_codes(start_date,rollback_weeks,include_this_week)
  url_code=paste(url_base,site,locale,dates,'full#type1',sep='/')
  url_code
}
