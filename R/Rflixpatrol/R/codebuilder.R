#code_builder
build_date_codes <- function(start_date,rollback_days,include_today=TRUE) {
  dates=lubridate::date(start_date)-(ifelse(include_today,0,1):rollback_days)
  as.character(dates)
}

build_chart_code <- function(start_date,rollback_days,locale='world',site="netflix",include_today=TRUE) {
 url_base="https://flixpatrol.com/top10"
 dates=build_date_codes(start_date,rollback_days,include_today)
 url_code=paste(url_base,site,locale,dates,'full',sep='/')
 url_code
}
