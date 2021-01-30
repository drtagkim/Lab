#py_install('google-cloud-vision',pip=TRUE)
###
###
source('gvision.r')
##
##

set_google_api('~/google_api_key.json')
##
##

o1=gVisionLabel('img/dog.jpg',vision,client) %>%
  filter(topicality>=0.95) %>%
  mutate(pid='dog.jpg')
o2=gVisionLabel('img/man.jpg',vision,client) %>%
  filter(topicality>=0.95) %>%
  mutate(pid="man.jpg")
result=bind_rows(o1,o2)