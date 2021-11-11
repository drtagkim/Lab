#googlesheets test
install.packages("googlesheets4")
library(googledrive)
library(googlesheets4)
drive_auth()
gs4_auth(token=drive_token())
ss = drive_find("fluffy")

ss <- gs4_create("fluffy-bunny",sheets=list(flowers=head(iris)))
