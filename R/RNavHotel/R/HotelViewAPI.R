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
    if('err' %in% names(result)) {
      cat("Error",result$errorMessage,'\n')
      return(NULL)
    }
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
extract_info <- function(dt) {
  data.frame(
    hotel_id=dt$id,
    key=dt$key,
    name=dt$name,
    description=dt$description,
    address=dt$address,
    latitude=dt$latitude,
    longitude=dt$longitude,
    starRating=dt$starRating
  )
}

extract_feature <- function(dt) {
  features=dt$features
  features_dt=features %>% map(function(f) {
    data.frame(
      name=f$name,
      facilities=paste(f$facilities,collapse=',')
    )
  }) %>% bind_rows() %>% distinct()
  features_dt
}

extract_place <- function(dt) {
  hierarchy=dt$place$hierarchy
  if(length(dt$place$hierarchy)<=0) return(NULL)
  hierarchy_dt=hierarchy %>% map(function(h) {
    data.frame(
      name=h$name,
      key=h$key
    )
  }) %>% bind_rows() %>%
    mutate(
      id=dt$place$id,
      key=dt$place$key,
      name=dt$place$name,
      fullName=dt$place$fullName,
      longitude=dt$place$longitude,
      latitude=dt$place$latitude
    )
  hierarchy_dt %>% distinct()
}

extract_provider <- function(dt) {
  providers=dt$providers
  results=dt$results
  if(length(providers)<=0) return(NULL)
  providers_df=providers %>% map(
    function(p) {
      data.frame(
        name=p$name,
        code=p$code
      )
    }
  ) %>% bind_rows() %>%
    mutate(providerIndex=row_number()-1)
  results_dt=results %>% map(
    function(r) {
      data.frame(
        providerIndex=r$providerIndex,
        totalRate=r$totalRate,
        roomName=r$roomName,
        groupingTitle=r$groupingTitle
      )
    }
  ) %>% bind_rows()
  suppressMessages({
    results_dtj=results_dt %>% left_join(providers_df)
  })
  results_dtj
}

extract_data <- function(dt,target_date=NULL,time_marker) {
  info=extract_info(dt)
  #
  hotel_id=info$hotel_id
  today_date=Sys.Date() %>% as.character()
  if(is.null(time_marker)) time_marker="000000"
  #
  features=extract_feature(dt)
  place=extract_place(dt)
  provider=extract_provider(dt)
  info$today_date=today_date
  info$target_date=target_date
  #
  features$hotel_id=hotel_id
  place$hotel_id=hotel_id
  provider$hotel_id=hotel_id
  ##
  features$target_date=target_date
  place$target_date=target_date
  provider$target_date=target_date
  ##
  features$today_date=today_date
  place$today_date=today_date
  provider$today_date=today_date
  ##
  features$time_marker=time_marker
  place$time_marker=time_marker
  provider$time_marker=time_marker
  #
  list(hotel_id=hotel_id,
       today_date=today_date,
       target_date=target_date,
       info=info,
       features=features,
       place=place,
       provider=provider)
}

gen_time_marker <- function() {
  x=Sys.time()
  strftime(x,'%H%M%S')
}

query_hotel <- function(key,target_date,time_marker=NULL,daysn=1) {
  d1=target_date
  d2=(lubridate::date(d1)+daysn) %>% as.character()
  x1=gen_query_hotel(key,d1,d2) %>% get_hotel_view()
  if(!is.null(x1)) {
    return(extract_data(x1,d1,time_marker))
  }
  NULL
}
