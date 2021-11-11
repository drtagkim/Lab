source('r/setting.R')

# Test --------------------------------------------------------------------
my_api_key <- file.choose()
login_youtube(my_api_key) #my_api_key.yaml

#channel_stats
# https://commentpicker.com/youtube-channel-id.php
x2=get_channel_videos_stat("UChhOtjq-3QyyLmP2jv9amrg")

#
x=bind_rows(x1,x2)
library(dplyr)
library(tidyr)
library(ggplot2)
x.g <- x %>% 
  select(id,time_log,viewCount) %>% 
  spread(key=time_log,value=viewCount)
x.g[[2]] = as.numeric(x.g[[2]])
x.g[[3]] = as.numeric(x.g[[3]])
x.g <- x.g %>% 
  mutate(inc=`2021-10-29 14:42:28`- `2021-10-25 13:05:47`>0)
x.g.i <- x.g %>% 
  filter(inc)
x.g.i <- x.g.i %>% 
  mutate(incm=x.g.i[[3]]-x.g.i[[2]])
x.g.i <- x.g.i %>% 
  arrange(desc(incm))
x.g.i %>% dplyr::top_n(10) %>% 
  select(-(2:4)) %>% 
  ggplot(aes(x=reorder(id,desc(incm)),y=incm)) +
  geom_col() +
  theme(axis.text.x = element_text(angle=90))

  