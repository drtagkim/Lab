#gvision.r
#Taekyung Kim, PhD. 
#Kwangwoon University
library(reticulate)
library(dplyr)

vision <- import('google.cloud.vision')
tagg<-import('vision')
client<-vision$ImageAnnotatorClient()
get_file<-tagg$get_file
get_image<-tagg$get_image
get_label<-tagg$get_label
#
set_google_api <- function(p) {
  Sys.setenv(GOOGLE_APPLICATION_CREDENTIALS=p)  
}
gVisionLabel <- function(fname,vision,client) {
  labels<-client %>% 
    get_file(fname) %>% 
    get_image(vision) %>% 
    get_label(client)
  as_tibble(labels)
}
