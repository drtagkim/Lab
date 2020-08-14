#collect data
collect_data <- function(con,table_name) {
  con %>% tbl(table_name) %>% collect()
}
list_tables <- function(con) {
  DBI::dbListTables(con)
}
table_name_contains <- function(con,name_part) {
  tables=list_tables(con)
  idx=str_detect(tables,regex(name_part,ignore_case=TRUE))
  tables[idx]
}
create_table_pack<-function(con,name_part) {
  tables <- table_name_contains(con,name_part)
  result=list()
  N=length(tables)
  for(i in 1:N) {
    cat(i,"/",N,"...working...")
    result[[i]]=collect_data(con,tables[i])
    cat("OK\n")
  }
  names(result)=tables
  result
}
