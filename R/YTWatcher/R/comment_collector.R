# Author: Taekyung Kim
# kimtk@kw.ac.kr
# YouTube Comment Data Collector
# Project in 2021
# -----------------------------------

# Lib ---------------------------------------------------------------------

library(tuber)
library(dplyr)
library(yaml)

# Function ----------------------------------------------------------------

#
# Google Cloud OAuth
# 
#
login_youtube <- function(yaml_file_name) {
  configuration = yaml.load_file(yaml_file_name)
  client_id=configuration$client_id
  key=configuration$key
  yt_oauth(client_id,key)
}
#
#
#
get_video_stats <- function(vid) {
  get_stats(video_id = vid) %>% data.frame()
}
#
#
#
get_video_comments <- function(vid,pageToken=NULL) {
  if(is.null(pageToken)) {
    r0=get_comment_threads(
      filter=c(video_id=vid),
      text_format='plainText',
      max_results=100,
      simplify=FALSE
    )
    token=r0$nextPageToken
    r=r0$items %>% 
      map_dfr(function(item) {
        tibble(
          id=item$id,
          videoId=item$snippet$videoId,
          authorDisplayName=item$snippet$topLevelComment$snippet$authorDisplayName,
          authorChannelId=item$snippet$topLevelComment$snippet$authorChannelId$value,
          canRate=item$snippet$topLevelComment$snippet$canRate,
          viewerRating=item$snippet$topLevelComment$snippet$viewerRating,
          likeCount=item$snippet$topLevelComment$snippet$likeCount,
          publishedAt=item$snippet$topLevelComment$snippet$publishedAt,
          totalReplyCount=item$snippet$totalReplyCount,
          textDisplay=item$snippet$topLevelComment$snippet$textDisplay
        )
      })
  } else {
    r0=get_comment_threads(
      filter=c(video_id=vid),
      text_format='plainText',
      max_results=100,
      simplify=FALSE,
      page_token=pageToken
    )
    token=r0$nextPageToken
    r=r0$items %>% 
      map_dfr(function(item) {
        tibble(
          id=item$id,
          videoId=item$snippet$videoId,
          authorDisplayName=item$snippet$topLevelComment$snippet$authorDisplayName,
          authorChannelId=item$snippet$topLevelComment$snippet$authorChannelId$value,
          canRate=item$snippet$topLevelComment$snippet$canRate,
          viewerRating=item$snippet$topLevelComment$snippet$viewerRating,
          likeCount=item$snippet$topLevelComment$snippet$likeCount,
          publishedAt=item$snippet$topLevelComment$snippet$publishedAt,
          totalReplyCount=item$snippet$totalReplyCount,
          textDisplay=item$snippet$topLevelComment$snippet$textDisplay
        )
      })    
  }
  if(is.null(token)) token=NA
  rr=cbind(token,r)
  names(rr)[1]='pageToken'
  rr
}
#
#
#
get_channel_data <- function(cid) {
  get_channel_stats(channel_id=cid) %>% 
    tibble(
      channel_id=.$id,
      title=.$snippet$title,
      publishedAt=.$snippet$publishedAt,
      local_title=.$snippet$localized$title,
      viewCount=.$statistics$viewCount,
      subscriberCount=.$statistics$subscriberCount,
      videoCount=.$statistics$videoCount
    ) %>% select(-1) %>% distinct()
}

# Test --------------------------------------------------------------------
login_youtube('my_api_key.yaml')
result=list()
i=1
pageToken=NULL
repeat {
  cat(i,".. processing\n")
  if(!is.null(pageToken)) {
    result[[i]]=get_video_comments(vid='3P1CnWI62Ik',pageToken)
  } else {
    result[[i]]=get_video_comments(vid='3P1CnWI62Ik')
  }
  pageToken=unique(result[[i]][1])
  if(is.na(pageToken)) break
  if(i>140) {
    break
  }
  i=i+1
}
#free malloc
rm(i)
results=bind_rows(result)
rm(result)
#View results
View(results)
# -----------------------
i=1
cids=unique(comment_data$authorChannelId.value)
cids=cids[!is.na(cids)]
N=length(cids)


#
#
result=list()
i=1
repeat {
  cat("Channel...",i,'')
  result[[i]]=get_channel_data(cids[i])
  i=i+1
  cat('OK\n')
}

results=bind_rows(result)
rm(i)

user_channel_stat <- results
names(user_channel_stat)[1] <- "authorChannelId.value"
saveRDS(user_channel_stat,'rds/user_channel_stat.rds')

writexl::write_xlsx(user_channel_stat,'xlsx/user_channel_stat.xlsx')
writexl::write_xlsx(comment_data,'xlsx/comment_data.xlsx')
comment_data_combined <- comment_data %>% 
  left_join(user_channel_stat,by="authorChannelId.value")
View(comment_data_combined)

saveRDS(comment_data_combined,'rds/comment_data_combined.rds')
writexl::write_xlsx(comment_data_combined,'xlsx/comment_data_combined.xlsx')
