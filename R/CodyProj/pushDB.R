#push providers.df
suppressMessages({
  library(mongolite)
  library(dplyr)
  library(DBI)
  library(RSQLite)
})

# MongoDB -----------------------------------------------------------------

mdb_factory <- function() {
  mongo(
    collection="test",
    url="mongodb://cody:cody12345@cody-dev.codymanager.com:9011/codyAnalytics"
  )
}
con_mongo <- mdb_factory()

# DB ----------------------------------------------------------------------
db_files <- list.files('.','*.db')
for (df in db_files) {
  cat("processing...",df)
  con_db <- dbConnect(SQLite(),df) #db connection
  providers <- con_db %>% tbl("provider") %>% collect() #target provider table
  cat(' -> uploading...')
  dbDisconnect(con_db)
  con_mongo$insert(providers)
  cat('OK\n')
}
con_mongo$disconnect()






