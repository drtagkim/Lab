source('import.R')

gen_query_hotel <- function(hotel_name,checkin,checkout) {
  API_HOTEL="https://m-hotel.naver.com/hotels/api/hotels/hotel"
  url=paste(API_HOTEL,hotel_name,sep=':')
  url<-modify_url(url,query=list(
    checkin=checkin,
    checkout=checkout,
    groupedFeatures="true",
    includeLocalTaxesInTotal="false",
    includeTaxesInTotal="false",
    retry=0,
    rooms=2,
    type="pc",
    view="booking"
  ))
  url
}
get_hotel_view <- function(query_url,wait_time=2,trial=5) {
  while(TRUE)
  {
    resp=GET(query_url)
    if(http_type(resp) != 'application/json')
    {
      stop("API did not return JSON.",call.=FALSE)
    }
    result=fromJSON(content(resp,'text'),simplifyVector = FALSE)
    if(result$isComplete)
    {
      break
    }
    if(trial<=0) {
      break
    }
    Sys.sleep(wait_time)
    trial=trial-1
  }
  result
}
#test
query_url<-gen_query_hotel('Nine_Tree_Premier_Hotel_Insadong','2020-10-01','2020-10-03')
temp <- get_hotel_view(query_url)
