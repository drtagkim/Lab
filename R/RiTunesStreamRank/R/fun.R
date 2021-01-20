get_data <- function(url) {
  dt=fromJSON(url)
  feed=dt$feed
  list(
    country=feed$country,
    result=feed$results %>% select(-genres),
    genres=feed$results$genres
  )
}
process_results <- function(obj,nation,type) {
  result=obj$result
  result <- result %>% mutate(ranking=row_number())
  result$nation=nation
  result$type=type
  result
}
process_genres <- function(obj,nation,type) {
  ids=obj$result$id
  genres=obj$genres
  N=1:length(genres)
  output=list()
  for(i in N) {
    g=genres[[i]]
    g$id=ids[[i]]
    output[[i]]=g
  }
  result=bind_rows(output)
  result$nation=nation
  result$type=type
  result
}

get_input_template <-function(fname) {
  if(!endsWith(fname,'.csv')) {
    fname=paste0(fname,'.csv')
  }
  itunes_rsst=cbind(data.frame(collect=1),itunes_rss)
  write.csv(itunes_rsst,file = fname,row.names=FALSE)
  cat("template file:",fname,"is written\nOpen the file to edit.")
}

run_rss <- function(fname=NULL) {
  if(is.null(fname)) {
    itunes_rssi=itunes_rss
  } else {
    itunes_rssi=read.csv(fname)
    itunes_rssi=subset(itunes_rssi,collect==1,select=c(url,nation,type))
  }
  N=1:nrow(itunes_rssi)
  output_result=list()
  output_genre=list()
  today=Sys.Date() %>% as.character()
  for(i in N) {
    url=itunes_rssi[i,'url']
    nation=itunes_rssi[i,'nation']
    type=itunes_rssi[i,'type']
    cat(i,nation,type)
    objs=get_data(url)
    results=process_results(objs,nation,type)
    genres=process_genres(objs,nation,type)
    #
    results$today=today
    genres$today=today
    output_result[[i]]=results
    output_genre[[i]]=genres
    cat('\n')
  }
  rm(N,url,nation,type)
  rm(objs,results,genres)
  rm(i)
  output_result = bind_rows(output_result)
  output_genre=bind_rows(output_genre)
  list(output_result=output_result,output_genre=output_genre)
}
export_tsv <- function(result_obj,fname) {
  today=Sys.Date() %>% as.character()
  fname_result=paste(today,fname,"result.tsv",sep='_')
  fname_genre=paste(today,fname,'genre.tsv',sep='_')
  write.table(result_obj$output_result,file = fname_result,sep = '\t')
  write.table(result_obj$output_genre,file = fname_genre, sep = '\t')
  cat("OK.\n")
}
export_sqlite <- function(result_obj,dbname) {
  today=Sys.Date() %>% as.character()
  con=dbConnect(SQLite(),dbname)
  result=result_obj$output_result
  genre=result_obj$output_genre
  table_names=con %>% dbListTables()
  if('itunes_genre' %in% table_names) {
    con %>% dbAppendTable('itunes_genre',genre)
  } else {
    con %>% copy_to(genre,'itunes_genre',temporary=FALSE)
  }
  if('itunes_result' %in% table_names) {
    con %>% dbAppendTable('itunes_result',result)
  } else {
    con %>% copy_to(result,'itunes_result',temporary=FALSE)
  }
  con %>% dbDisconnect()
}
run_to_sqlite <- function(dbname='test.db',input_file=NULL) {
  if(is.null(input_file)) {
    objs=run_rss()
  } else {
    objs=tryCatch({run_rss(input_file)},error=function(e){
      NULL
    })
    if(is.null(objs)) {
      cat("ERROR: input file\n")
      return(objs)
    }
  }
  cat("Database working at",dbname,'...')
  export_sqlite(objs,dbname)
  cat("OK.\n")
  cat("Bye.")
}
