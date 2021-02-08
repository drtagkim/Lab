#codycompetitorapi.r
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
# API ---------------------------------------------------------------------
check_hotel_competitor_api <- function() {
  reqPkg('httr')
  address="http://cody-dev.codymanager.com:9001/ext-api/hotel/search"
  api_key='78e7446c923047dd9fec772b395e3c9c'
  page=GET(address,add_headers(`EX-API-KEY`=api_key))
  status_code=page$status_code
  if(status_code==200) {
    return(content(page))
  }
  NULL
}#END of check_hotel_competitor_api()
extract_competitor_hotelid <- function(api_data) {
  #api_data - check_hotel_competitor_api()
  reqPkg('purrr')
  reqPkg('dplyr')
  api_data %>%
    set_names(map_chr(.,function(x) x$hotelCode )) %>%
    map(~.x$competitors %>%
          map(~.x$hotelId) %>%
          unlist())
}#END of extract_competitor_hotelid()
# Test --------------------------------------------------------------------
# test<-check_hotel_competitor_api()
# extract_competitor_hotelid(test)
