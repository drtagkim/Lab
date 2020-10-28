library(lubridate)
library(dplyr)
library(RNavHotel)
library(purrr)
hotel_key1='Nine_Tree_Premier_Hotel_Insadong'
target_date='2020-11-01'
target_date_set=date(target_date)+1:30
target_date_set=as.character(target_date_set)
data.frame(x=target_date_set) %>%
  map(function(x) {
    cat(x,'\n')
    query_hotel(hotel_key1,x) %>% update_data_sqlite('test.db')
  })



test=query_hotel(hotel_key1,target_date)
update_data_sqlite(test,'test.db')
