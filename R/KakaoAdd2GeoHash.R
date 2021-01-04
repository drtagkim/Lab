library(httr)
library(jsonlite)
library(geohashTools)
library(dplyr)
library(foreach)

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
  unique(x1$gh)
}

queries=c(
  '서울식물원',
  '경복궁',
  '남산서울타워',
  '서울숲'
)

KAKAO_MAP_API_KEY=readLines('kakao_api_key.txt')

test=foreach(q=queries, .combine=bind_rows) %do% {
  tibble(q,kakao(KAKAO_MAP_API_KEY,q))
}
test
