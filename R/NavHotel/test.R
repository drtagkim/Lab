library(lubridate)
library(dplyr)
library(RNavHotel)
library(purrr)
hotel_key1='Nine_Tree_Premier_Hotel_Insadong'
target_date='2020-11-01'
target_date_set=date(target_date)+1:60
target_date_set=as.character(target_date_set)
time_marker=gen_time_marker()
for(x in target_date_set) {
  cat(x)
  query_hotel(hotel_key1,x,time_marker) %>% update_data_sqlite('test1.db')
  cat("...sleeping.")
  Sys.sleep(10) #ten seconds waiting.
  cat('\n')
}

