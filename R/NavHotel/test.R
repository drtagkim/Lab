hotel_key1='Nine_Tree_Premier_Hotel_Insadong'
target_date='2020-11-01'
library(lubridate)
library(dplyr)
library(RNavHotel)
test=query_hotel(hotel_key1,target_date)
update_data_sqlite(test,'test.db')
