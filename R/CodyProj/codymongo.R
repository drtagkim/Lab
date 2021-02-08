#codymongo.R
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

# mongo -------------------------------------------------------------------

cody_mongo <- function(collection_name) {
  #loading packages
  reqPkg("mongolite")
  #factory
  mdb_factory <- function(collection_name) {
    mongo(
      collection=collection_name,
      url="mongodb://cody:cody12345@cody-dev.codymanager.com:9011/codyAnalytics"
    )
  }
  mdb_factory(collection_name) #deligation
}#END of cody_mongo()
disconnect_mongo <- function(x) {
  #x - connection
  #loading library
  reqPkg("mongolite")
  x$disconnect() #disconnect mongodb
}#END of disconnect_mongo()
cody_price_query_competitor <- function(con,competitors=NULL,td=NULL,today=NULL) {
  #con - connection
  #competitors - numeric, competitors of a given hotel
  #td - target time 2000-00-00 character
  #loading library
  reqPkg("mongolite")
  #query string
  if(is.null(competitors)) {
    if(is.null(td)) {
      if(is.null(today)) {
        qstring='{}'  
      } else{
        qsting=sprintf('{"today_date":"%s"}',today) 
      }
    } else {
      if(is.null(today)) {
        qstring=sprintf('{"target_date":{"$gte":"%s"}}',td)   
      } else {
        qstring=sprintf('{"target_date":{"$gte":"%s"},"today_date":"%s"}',td,today)   
      }
    }
  } else {
    if(is.null(td)) {
      if(is.null(today)) {
        qstring=sprintf('{"hotel_id":{"$in":%s}}',jsonlite::toJSON(competitors))      
      } else {
        qstring=sprintf('{"hotel_id":{"$in":%s},"today_date":"%s"}',jsonlite::toJSON(competitors),today)    
      }
    } else {
      if(is.null(today)) {
        qstring=sprintf('{"hotel_id":{"$in":%s},"target_date":{"$gte":"%s"}}',jsonlite::toJSON(competitors),td)      
      } else {
        qstring=sprintf('{"hotel_id":{"$in":%s},"target_date":{"$gte":"%s"},"today_date":"%s"}',jsonlite::toJSON(competitors),td,today)     
      }
    }
  }
  #execute query
  con$find(qstring,fields='{"_id":0
           ,"code":1
           ,"hotel_id":1
           ,"target_date":1
           ,"groupingTitle":1
           ,"totalRate":1
           }')
}#END of cody_price_query_competitor


# Sample ------------------------------------------------------------------


# con <- cody_mongo("marketprice01")
# con$count()
# test<-con$iterate()$one() #iteratre one collection
# View(data.frame(test),'test')
# length(con$distinct('code')) #how many distinct items?
# con$count('{"code":"AGD"}') #how many Agoda items?
# q1<-cody_price_query_competitor(con,c(1063692,1195044),'2021-01-20')
# q1<-cody_price_query_competitor(con,competitors=competitors[[1]],td='2021-02-01',today='2021-01-31')
# disconnect_mongo(con)
