# Sentiment analysis Google NLP
# Taekyung Kim, PhD, Associate Professor.
# kimtk@kw.ac.kr, Kwangwoon Univ. 
# 2021-02-01

# Library -----------------------------------------------------------------

library(furrr)
library(dplyr)
library(googleLanguageR)


# Global variable ---------------------------------------------------------

Google_Credential_json_ENV = 'GOOGLE_APPLICATION_CREDENTIALS'

# Setting and Functions ---------------------------------------------------

gl_auto_auth(Google_Credential_json_ENV) #google credential json file location

gl_sent <- function(txt) {
  gl_nlp(txt) %>% .$sentences
}
gl_sent_summary <- function(obj) {
  rv=NULL
  if(length(obj)>0) {
    rv=obj[[1]] %>% 
      select(beginOffset,score,magnitude) %>% 
      mutate(seq=row_number())
  }
  rv
}
gl_sent_overall <- function(obj) {
  mean(obj$magnitude*obj$score)
}

# Sample ------------------------------------------------------------------


text = "
Tonal shifts. 
Snow Crash starts with some legendary levels of satire, but the consistency for said tone drops off after 50 or 60 pages. 
The satire remains, but the more the novel progresses, the more an afterthought that satire seems. 
In the middle of the book, the tone becomes one of discovery/revelation that persists until the end… at which point the tone graduates to let’s get this over.
The shifts are never quite abrupt, but are somewhat stark.
"
#call Google API
obj <- text %>% gl_sent()
#sentitment score by sentence
obj %>% gl_sent_summary()
#overall sentitment score
obj %>% gl_sent_summary() %>% gl_sent_overall()


# Multiprocessing ---------------------------------------------------------

# NO MORE THAN 15 items per batch!
text_list <- list(text,text,text,text,text,text,text,text,text,text,text,text,text,text,text)

# CPU plan
plan(multisession,workers=4) #2 cores

result <- text_list %>% 
  future_map(function(item) {
    item %>% gl_sent() %>% 
      gl_sent_summary() %>% 
      gl_sent_overall()
  })
