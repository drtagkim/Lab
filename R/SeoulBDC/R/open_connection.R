#R setup for connecting to MySQL in Big Data Campus.
open_connection <- function(dbname='bigdata') {
  con <- DBI::dbConnect(RMySQL::MySQL(),
                        host='98.44.10.40',
                        user='bigdatadb',
                        password='bigdatadb1!',
                        dbname=dbname)
  suppressWarnings({
    DBI::dbSendQuery(con,'SET NAMES utf8;')
    DBI::dbSendQuery(con,'SET CHARACTER SET utf8;')
    DBI::dbSendQuery(con,'SET character_set_connection=utf8;')
  })
}
