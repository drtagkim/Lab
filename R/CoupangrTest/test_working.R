source('literal.R')

library(tidyverse)
library(rvest)
library(chromote)

b=ChromoteSession$new()
b$view()
b$Page$navigate('https://www.coupang.com/')
b$screenshot('test.png')
b$Page$navigate(test.url)

require(RSelenium)
pJS <- wdman::phantomjs(port = 123L)
remDr <- remoteDriver(browserName='phantomjs',port=123L)
remDr$open()
remDr$navigate(test.url)
remDr