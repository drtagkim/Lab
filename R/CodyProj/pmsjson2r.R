# How to ------------------------------------------------------------------
# $ Rscript --vanilla pmsjson2r.r 20210101
# 20210101 -> tag
# outuput file: 20210101_reservation_items.RData, 20210101_roomrate_items.RData
# --> tibble objects
# .. Taekyung Kim (kimtk@office.kw.ac.kr) Kwangwoon University, PhD.
# .. ver. 1.0.0.

#Util----
reqPkg <- function(PKG) {
  REPO="https://cran.rstudio.com"
  suppressMessages({
    if(!require(PKG,character.only=TRUE,quietly=TRUE)) install.packages(PKG,repos=REPO,quiet=TRUE,verbose=FALSE)
    require(PKG,character.only=TRUE,quietly=TRUE,verbose=FALSE)
  })
}

# Source code -------------------------------------------------------------

suppressMessages({
  suppressWarnings({
    reqPkg('dplyr')
    reqPkg('jsonlite')
    reqPkg('stringr')
    reqPkg('foreach')
    reqPkg('purrr')
    reqPkg('readr')
    args<-commandArgs(trailingOnly = TRUE)
    if(length(args)<1) {
      tag="00000000"
    } else {
      tag=args[1]
    }
    dir_hotels<-list.dirs('.',recursive=FALSE) %>% .[str_detect(.,"^\\./[^\\.]")]
    x1<-foreach(dh=dir_hotels) %do% {
      reservation_files=list.files(dh,full.names=TRUE,recursive=TRUE) %>% .[str_detect(.,'reservation\\.txt$')]
      roomrate_files=list.files(dh,full.names=TRUE,recursive=TRUE) %>% .[str_detect(.,'roomrate\\.txt$')]
      reservation_item=foreach(x=reservation_files,.combine=bind_rows) %do% {
        #hotel_id=x %>% str_split_fixed('/',3) %>% .[2]
        read_json(x,simplifyVector = TRUE)
      }
      roomrate_item=foreach(x=roomrate_files,.combine=bind_rows) %do% {
        hotel_id=x %>% str_split_fixed('/',3) %>% .[2]
        y=read_json(x,simplifyVector = TRUE)
        y$hotel_id=hotel_id
        y
      }
      list(reservation=reservation_item,roomrate=roomrate_item)
    }
    reservation_items<-foreach(x=x1,.combine=bind_rows) %do% x$reservation
    roomrate_items<-foreach(x=x1,.combine=bind_rows) %do% x$roomrate
    save(reservation_items,file=sprintf("%s_reservation_items.RData",tag))
    write_csv(reservation_items,sprintf("%s_reservation_items.RData",tag))
    save(roomrate_items,file=sprintf("%s_roomrate_items.RData",tag))
    write_csv(roomrate_items,sprintf("%s_roomrate_items.RData",tag))
    rm(list=ls())   
  })
})
