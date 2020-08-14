close_connection <- function(con) {
  DBI::dbDisconnect(con)
}
