# Creating google environment.
google_env <- function() {
  g=import('google.cloud')
  lan=g$language_v1
  client=lan$LanguageServiceClient()
  list(lan=lan,client=client)
}

# -------------------------------------------------------------------------

request_sentiment_result <- function(genv,text) {
  lan=genv$lan
  client=genv$client
  document=lan$Document(content=text,type_=lan$Document$Type$PLAIN_TEXT)
  req_obj=dict(list(document=document))
  client$analyze_sentiment(request=req_obj)
}

request_entity_result <- function(genv,text) {
  lan=genv$lan
  client=genv$client
  document=lan$Document(content=text,type_=lan$Document$Type$PLAIN_TEXT)
  req_obj=dict(list(document=document))
  client$analyze_entities(request=req_obj)
}
# -------------------------------------------------------------------------

analyze_magnitude <- function(sent) {
  sent$document_sentiment$magnitude
}

analyze_sentiment <- function(sent) {
  sent$document_sentiment$score
}

analyze_sentences <- function(sent) {
  sentences=sent$sentences
  x=as_iterator(sentences)
  x1=iter_next(x)
  result_lst=list()
  cnt=1
  while(!is.null(x1)) {
    result_lst[[cnt]]=tibble(
      score=x1$sentiment$score,
      magnitude=x1$sentiment$magnitude,
      text=x1$text$content)
    x1=iter_next(x)
    cnt=cnt+1
  }
  bind_rows(result_lst)
}

analyze_entities <- function(ent) {
  entities=ent$entities
  x=as_iterator(entities)
  x1=iter_next(x)
  result_list=list()
  cnt=1
  while(!is.null(x1)) {
    result_list[[cnt]]=tibble(
      name=x1$name,
      type=as.character(x1$type_),
      salience=x1$salience)
    x1=iter_next(x)
    cnt=cnt+1
  }
  bind_rows(result_list)
}
