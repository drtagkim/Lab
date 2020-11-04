extract_history <- function(dt) {
  yr=dt[[2]] %>% html_nodes('tbody > tr > td:nth-child(1)') %>% html_text() %>% str_trim()
  if(yr[1]=='회사연혁 정보가 없습니다.') return(NULL)
  content=dt[[2]] %>% html_nodes('tbody > tr > td:nth-child(2)') %>% html_text() %>% str_trim()
  data.frame(yr,content)
}

extract_person <- function(dt) {
  i=3
  job=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(1)') %>% html_text() %>% str_trim()
  date=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(2)') %>% html_text() %>% str_trim()
  name=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(3)') %>% html_text() %>% str_trim()
  position=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(4)') %>% html_text() %>% str_trim()
  isSenior=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(5)') %>% html_text() %>% str_trim()
  isExpert=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(6)') %>% html_text() %>% str_trim()
  if(length(date)<=0) return(NULL)
  data.frame(job,
             date,
             name,
             position,
             isSenior,
             isExpert)
}
extract_capital <- function(dt) {
  i=4
  date=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(1)') %>% html_text() %>% str_trim()
  amount=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(2)') %>% html_text() %>% str_trim()
  pricePerShare=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(3)') %>% html_text() %>% str_trim()
  issuePricePerShare=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(4)') %>% html_text() %>% str_trim()
  capitalChanged=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(5)') %>% html_text() %>% str_trim()
  newIssueMethod=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(6)') %>% html_text() %>% str_trim()
  IncreaseRate=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(7)') %>% html_text() %>% str_trim()
  type=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(8)') %>% html_text() %>% str_trim()
  cause=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(9)') %>% html_text() %>% str_trim()
  if(length(amount)<=0) return(NULL)
  data.frame(date,
             amount,
             pricePerShare,
             issuePricePerShare,
             capitalChanged,
             newIssueMethod,
             IncreaseRate,
             type,
             cause)
}
extract_bspl <- function(dt) {
  i=6
  accountName=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(1)') %>% html_text() %>% str_trim()
  rule=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(2)') %>% html_text() %>% str_trim()
  financeType=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(3)') %>% html_text() %>% str_trim()
  yearMonth=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(4)') %>% html_text() %>% str_trim()
  bspl=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(5)') %>% html_text() %>% str_trim()
  if(length(rule)<=0) return(NULL)
  data.frame(
    accountName,
    rule,
    financeType,
    yearMonth,
    bspl
  )
}
extract_funding <- function(dt) {
  i=8
  category=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(1)') %>% html_text() %>% str_trim()
  if(category[1]=="출자자현황 정보가 없습니다.") return(NULL)
  amount=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(2)') %>% html_text() %>% str_trim()
  rate=dt[[i]] %>% html_nodes('tbody > tr > td:nth-child(3)') %>% html_text() %>% str_trim()
  data.frame(
    category,
    amount,
    rate
  )
}

extract_company_info <- function(dt) {
  i=1
  name=dt[[i]] %>% html_nodes('tbody > tr:nth-child(1) > td:nth-child(2)') %>% html_text() %>% str_trim()
  ceo=dt[[i]] %>% html_nodes('tbody > tr:nth-child(1) > td:nth-child(4)') %>% html_text() %>% str_trim()
  address=dt[[i]] %>% html_nodes('tbody > tr:nth-child(5) > td') %>% html_text() %>% str_trim()
  founded=dt[[i]] %>% html_nodes('tbody > tr:nth-child(6) > td') %>% html_text() %>% str_trim()
  if(length(ceo)<=0) return(NULL)
  data.frame(
    name,ceo,address,founded
  )
}
extract_performance <- function(dt) {
  i=7
  currentRatio=dt[[i]] %>% html_nodes('tbody > tr:nth-child(1) > td.ar') %>% html_text() %>% str_trim()
  debitRatio=dt[[i]] %>% html_nodes('tbody > tr:nth-child(2) > td.ar') %>% html_text() %>% str_trim()
  saleOperatingMargin=dt[[i]] %>% html_nodes('tbody > tr:nth-child(3) > td.ar') %>% html_text() %>% str_trim()
  netMarginOfSales=dt[[i]] %>% html_nodes('tbody > tr:nth-child(4) > td.ar') %>% html_text() %>% str_trim()
  totalAssetNetIncomeRatio=dt[[i]] %>% html_nodes('tbody > tr:nth-child(5) > td.ar') %>% html_text() %>% str_trim()
  returnOnEquityCapital=dt[[i]] %>% html_nodes('tbody > tr:nth-child(6) > td.ar') %>% html_text() %>% str_trim()
  salesGrowthRate=dt[[i]] %>% html_nodes('tbody > tr:nth-child(7) > td.ar') %>% html_text() %>% str_trim()
  OperatingProfitGrowthRate=dt[[i]] %>% html_nodes('tbody > tr:nth-child(8) > td.ar') %>% html_text() %>% str_trim()
  netIncomeGrowthRate=dt[[i]] %>% html_nodes('tbody > tr:nth-child(9) > td.ar') %>% html_text() %>% str_trim()
  totalAssetGrowthRate=dt[[i]] %>% html_nodes('tbody > tr:nth-child(10) > td.ar') %>% html_text() %>% str_trim()
  assetTurnover=dt[[i]] %>% html_nodes('tbody > tr:nth-child(11) > td.ar') %>% html_text() %>% str_trim()
  if(length(debitRatio)<=0) return(NULL)
  data.frame(
    currentRatio,
    debitRatio,
    saleOperatingMargin,
    netMarginOfSales,
    totalAssetNetIncomeRatio,
    returnOnEquityCapital,
    salesGrowthRate,
    OperatingProfitGrowthRate,
    netIncomeGrowthRate,
    totalAssetGrowthRate,
    assetTurnover
  )
}
write_database <- function(obj_list,dbname) {
  N=length(obj_list)
  i=1
  for(obj in obj_list) {
    cat('[',i,']th of',N)
    con <- dbConnect(SQLite(),dbname)
    tables = dbListTables(con)
    if(!is.null(obj$history)) {
      if('history' %in% tables) {
        dbAppendTable(con,'history',obj$history)
      } else {
        con %>% copy_to(obj$history,'history',overwrite=FALSE,temporary=FALSE)
      }
    }
    if(!is.null(obj$person)) {
      if('person' %in% tables) {
        dbAppendTable(con,'person',obj$person)
      } else {
        con %>% copy_to(obj$person,'person',overwrite=FALSE,temporary=FALSE)
      }
    }
    if(!is.null(obj$capital)) {
      if('capital' %in% tables) {
        dbAppendTable(con,'capital',obj$capital)
      } else {
        con %>% copy_to(obj$capital,'capital',overwrite=FALSE,temporary=FALSE)
      }
    }
    if(!is.null(obj$bspl)) {
      if('bspl' %in% tables) {
        dbAppendTable(con,'bspl',obj$bspl)
      } else {
        con %>% copy_to(obj$bspl,'bspl',overwrite=FALSE,temporary=FALSE)
      }
    }
    if(!is.null(obj$funding)) {
      if('funding' %in% tables) {
        dbAppendTable(con,'funding',obj$funding)
      } else {
        con %>% copy_to(obj$funding,'funding',overwrite=FALSE,temporary=FALSE)
      }
    }
    if(!is.null(obj$company_info)) {
      if('company_info' %in% tables) {
        dbAppendTable(con,'company_info',obj$company_info)
      } else {
        con %>% copy_to(obj$company_info,'company_info',overwrite=FALSE,temporary=FALSE)
      }
    }
    if(!is.null(obj$performance)) {
      if('performance' %in% tables) {
        dbAppendTable(con,'performance',obj$performance)
      } else {
        con %>% copy_to(obj$performance,'performance',overwrite=FALSE,temporary=FALSE)
      }
    }
    dbDisconnect(con)
    cat('\n')
    i=i+1
  }
  cat("Done.\n")
}
run <- function(fname,year=NULL) {
  page <- read_html(fname,encoding='utf8')
  if(is.null(year)) {
    year=str_match(fname,'([0-9]+)_')[1,2]
    if(is.na(year)) {
      year="0000"
    }
  } else {
    year=as.character(year)
  }
  tables=tryCatch(page %>% html_nodes("table"),error=function(e){list()})
  if(length(tables)<=0) {
    return(list())
  }
  history=extract_history(tables)
  person=extract_person(tables)
  capital=extract_capital(tables)
  bspl=extract_bspl(tables)
  funding=extract_funding(tables)
  company_info=extract_company_info(tables)
  performance=extract_performance(tables)
  #processing keys
  nameKey=company_info$name
  ##
  if(!is.null(history) && nrow(history)>0) history$year=year
  if(!is.null(person) && nrow(person)>0) person$year=year
  if(!is.null(capital) && nrow(capital)>0) capital$year=year
  if(!is.null(bspl) && nrow(bspl)>0) bspl$year=year
  if(!is.null(funding) && nrow(funding)>0) funding$year=year
  if(!is.null(company_info) && nrow(company_info)>0) company_info$year=year
  if(!is.null(performance) && nrow(performance)>0) performance$year=year
  ##
  if(!is.null(history) && nrow(history)>0) history$nameKey=nameKey
  if(!is.null(person) && nrow(person)>0) person$nameKey=nameKey
  if(!is.null(capital) && nrow(capital)>0) capital$nameKey=nameKey
  if(!is.null(bspl) && nrow(bspl)>0) bspl$nameKey=nameKey
  if(!is.null(funding) && nrow(funding)>0) funding$nameKey=nameKey
  if(!is.null(company_info) && nrow(company_info)>0) company_info$nameKey=nameKey
  if(!is.null(performance) && nrow(performance)>0) performance$nameKey=nameKey
  list(
    history=history,
    person=person,
    capital=capital,
    bspl=bspl,
    funding=funding,
    company_info=company_info,
    performance=performance
  )
}
