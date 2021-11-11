# title: functions
# author: taekyung kim
# updated: 2021-10-25

#
# Google Cloud OAuth
# 
#=
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
#
#
#
get_channel_videos_stat <- function(cid) {
  v_list = list_channel_videos(channel_id = cid,max_results = 100)
  v_stats = v_list$`contentDetails.videoId` %>% 
    map_dfr(function(vid) {
      get_stats(vid)
    })
  cbind(channel_id=cid,
        time_log=as.character(Sys.time()),
        v_stats)
}
