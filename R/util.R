#Taekyung Kim
#
reqPkg <- function(PKG) {
  REPO="https://cran.rstudio.com"
  suppressMessages({
    if(!require(PKG,character.only=TRUE,quietly=TRUE)) install.packages(PKG,repos=REPO,quiet=TRUE)
    require(PKG,character.only=TRUE,quietly=TRUE)
  })
}

#font-ggplot2
installKorFont <- function() {
  reqPkg('ggplot2')
  install.packages("extrafont")
  library(extrafont)
  font_import()
}