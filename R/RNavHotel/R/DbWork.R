#DataBase Work
update_data_sqlite <- function(dt,filename='test.db') {
  con <- DBI::dbConnect(RSQLite::SQLite(), filename)
  tables <- con %>% dbListTables()
  tryCatch(
    {
      if('info'%in%tables) {
        con %>% dbAppendTable('info',dt$info)
      } else {
        copy_to(con,dt$info,'info',overwrite=FALSE,temporary=FALSE)
      }
    },error=function(e) {}
  )
  tryCatch(
    {
      if('features'%in%tables) {
        con %>% dbAppendTable('features',dt$features)
      } else {
        copy_to(con,dt$features,'features',overwrite=FALSE,temporary=FALSE)
      }
    },error=function(e) {}
  )
  tryCatch(
    {
      if('place'%in%tables) {
        con %>% dbAppendTable('place',dt$place)
      } else {
        copy_to(con,dt$place,'place',overwrite=FALSE,temporary=FALSE)
      }
    },error=function(e) {}
  )
  tryCatch(
    {
      if(length(dt$provider)>4) {
        if('provider'%in%tables) {
          con %>% dbAppendTable('provider',dt$provider)
        } else {
          copy_to(con,dt$provider,'provider',overwrite=FALSE,temporary=FALSE)
        }
      }
    },error=function(e) {}
  )
  con %>% dbDisconnect()
}
