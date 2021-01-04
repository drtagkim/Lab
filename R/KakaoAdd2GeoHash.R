library(httr)
library(jsonlite)
library(geohashTools)
library(dplyr)

kakao<-function(KAKAO_MAP_API_KEY,q) {
  url_keyword='https://dapi.kakao.com/v2/local/search/keyword.json' #local api
  url_address='https://dapi.kakao.com/v2/local/search/address.json'
  header=paste0('KakaoAK ',KAKAO_MAP_API_KEY)
  x<-GET(url_keyword,
         query=list(query=q),
         add_headers(Authorization=header))
  x1=x %>% 
    content(as='text') %>% 
    fromJSON() %>% 
    .$documents %>% 
    select(place_name, category_name, latitude=y,longitude=x) %>%
    mutate(gh=gh_encode(latitude,longitude))
  x1
}

KAKAO_MAP_API_KEY = "3eed8462790bff2c3026da080238c6bf"