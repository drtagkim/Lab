# Title: YouTube Channel Watcher
# Description: functions
# Author: Taekyung Kim(associate professor, Kwangwoon University, Korea)
# Updated: 2021-11-15


login_youtube <- function(yaml_file_name) {
  configuration = yaml.load_file(yaml_file_name)
  client_id=configuration$client_id
  key=configuration$key
  yt_oauth(client_id,key)
}

get_video_stats <- function(vid) {
  get_stats(video_id = vid) %>% data.frame()
}

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

get_channel_videos_stat <- function(country,cid) {
  v_list = get_all_channel_video_stats(channel_id = cid)
  cbind(country=country,channel_id=cid,
        time_log=as.character(Sys.time()),
        v_list)
}

send_email <- function(df) {
  delete_temp_files() #delete temp files first.
  time_log=unique(df$time_log)[1]
  path_output=tempfile(pattern=paste0('yt_channel_',time_log),fileext='.xlsx')
  writexl::write_xlsx(df,path_output)
  email <- emayili::envelope() %>% 
    from(emailconf$from) %>% 
    to(c('snumuse@naver.com')) %>% 
    subject(emailconf$subject) %>% 
    html(paste0('Snapshot time:',
                as.character(Sys.time()),
                emailconf$header,
                '<h3>Channel Country List:</h3>',
                '<ul><li>',
                paste(df$Country,collapse='</li><li>'),
                '</li></ul>',
                emailconf$footer,collapse='')) %>% 
    attachment(path_output)
  smtp <- emayili::server(
    host = emailconf$host,
    port = emailconf$port,
    username = emailconf$user,
    password = emailconf$password
  )
  smtp(email,verbose=F)
}

delete_temp_files <- function() {
  PCTempDir <- Sys.getenv("TEMP")
  folders <- dir(PCTempDir, pattern = "Rtmp", full.names = TRUE)
  unlink(folders, recursive = TRUE, force = TRUE, expand = TRUE)
}

get_channel_ids_from_file <- function(fname) {
  result = tryCatch({
    cn = yaml::read_yaml(fname)
    cids = cn %>% 
      map(function(x) {v=x$ChannelId;ifelse(is.null(v),NA,v)}) %>% 
      unlist()
    cnames = cn %>% 
      map(function(x) {v=x$Country;ifelse(is.null(v),NA,v)}) %>% 
      unlist()
    tibble(Country=cnames,ChannelId=cids)
  },error=function(e){return(NULL)})
  result
}

collect_channel_info <- function(send_mail=TRUE) {
  result = list()
  dt=get_channel_ids_from_file(literal$Channel_file) 
  dt=dt %>% filter(!is.na(ChannelId))
  dt=data.frame(dt)
  N=nrow(dt)
  for(i in 1:N) {
    country=dt[i,'Country']
    cid=dt[i,'ChannelId']
    cat(paste0('[',i,'/',N,'] Collecting channel: ',cid,"..."))
    result[[i]]=get_channel_videos_stat(country,cid) #cid
    cat("OK.\n")
  }
  cat("Complete.\n")
  results=bind_rows(result)
  if(send_mail) {
    send_email(results)
  }
  results
}

