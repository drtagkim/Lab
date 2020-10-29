library(lubridate)
library(dplyr)
library(RNavHotel)
library(purrr)
hotel_key1='Nine_Tree_Premier_Hotel_Insadong'
target_date='2020-11-01'
target_date_set=date(target_date)+31:90
target_date_set=as.character(target_date_set)
for(x in target_date_set) {
  cat(x,'\n')
  query_hotel(hotel_key1,x) %>% update_data_sqlite('test.db')
}

