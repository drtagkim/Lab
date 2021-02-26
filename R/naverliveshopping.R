# ======================================================
#          Naver Shopping Live Data Collection
# ------------------------------------------------------
# Contact: kimtk@office.kw.ac.kr (Tae-kyung Kim)
#          Associate Professsor, PhD.
#          Business School
#          Kwangwoon University
# Update: 2021-02-26
# ======================================================
args=commandArgs(trailingOnly=TRUE)
if(length(args==0)) {
    stop("Please input Video URL. See also the manual!",call.=FALSE)
}

# ---- Loading packages ----
reqPkg("remotes")
reqPkg("dplyr")
reqPkg("utf8")
reqPkg("stringr")
if(!require("chromote")) {
    cat("Installing chromote...")
    suppressMessages(suppressWarnings(remotes::install_github("rstudio/chromote")))
    cat("... complete.\n")
}
require(chromote,quietly=TRUE)

# ---- Functions ----
reqPkg <- function(PKG) {
  REPO="https://cran.rstudio.com"
  suppressWarnings({
    suppressMessages({
        if(!require(PKG,character.only=TRUE,quietly=TRUE)) install.packages(PKG,repos=REPO,quiet=TRUE)
        require(PKG,character.only=TRUE,quietly=TRUE)
    })
  })
}

createBrowser <- function() {
  b<-ChromoteSession$new() #new session
  b
}
visitLink <- function(b,link,waitForSec=5) {
  invisible({
    b$Page$navigate(link,wait_=FALSE)
    b$Page$loadEventFired()
    Sys.sleep(waitForSec)
  })
}
getVideoLength <- function(b) {
  code="#root > div > div > div > div > div > div > div > div.NativePlayer_wrap_2FTTe > video"
  output=b$Runtime$evaluate(sprintf('document.querySelector("%s").duration',code))
  as.numeric(output$result$value)
}
getCurrentVideoTime <- function(b) {
  code="#root > div > div > div > div > div > div > div > div.NativePlayer_wrap_2FTTe > video"
  output=b$Runtime$evaluate(sprintf('document.querySelector("%s").currentTime',code))
  as.numeric(output$result$value)
}
extractData <- function(b,css_code,trial=5,verbose=TRUE) {
  while(trial>0) {
    selectorCode=sprintf('document.querySelector("%s").innerHTML',css_code)
    output<-b$Runtime$evaluate(selectorCode)
    if(!is.null(output$result$value)) break
    if(verbose) cat('.')
      trial=trial-1
    Sys.sleep(1)
  }
  if(verbose) cat("\n")
  output$result$value
}
getComments <- function(b,waitFor=60*2,verbose=TRUE) {
  fun <- function(x) {
    output<-b$Runtime$evaluate(x)
    output<-output$result$value
    output
    utf8::utf8_format(output)
  }
  result=list()
  timeTick=0
  moment=1
  video_length=getVideoLength(b)
  while(!is_video_finished(b)) {
    code="#root > div > div > div > div > div > div > div > div.Comment_wrap_3ylpz > div > div:nth-child(1) > div > span"
    codeEval=sprintf('document.querySelectorAll("%s").length',code)
    output<-b$Runtime$evaluate(codeEval)
    output<-as.numeric(output$result$value)
    if(output>0) {
      items=1:output
      codeEvala=sprintf('document.querySelector("#root > div > div > div > div > div > div > div > div.Comment_wrap_3ylpz > div > div:nth-child(1) > div:nth-child(%d) > span").innerHTML',items)
      codeEvalb=sprintf('document.querySelector("#root > div > div > div > div > div > div > div > div.Comment_wrap_3ylpz > div > div:nth-child(1) > div:nth-child(%d) > strong").innerHTML',items)
      comment=as.character(sapply(codeEvala,fun))
      user=as.character(sapply(codeEvalb,fun))
      result[[moment]]=data.frame(user,comment)
      moment=moment+1
    }
    #
    if(verbose) {
        show_video_progress(b,video_length)
    }
    if(timeTick>=waitFor) {
        if(verbose) {
            cat("Time's up.\n")
        }
      break
    }
    timeTick=timeTick+1
    Sys.sleep(1) #one sec buffering
  }
  result
}
show_video_progress <- function(b,video_length) {
    current_time=getCurrentVideoTime(b)
    sprintf("[%.4f] percent current time=%d  video length=%d",(current_time/video_length*100),current_time,video_length)
}
set_playBackRate <- function(b,faster=TRUE) {
    if(faster) {
        b$Runtime$evaluate('var v1=document.querySelector("video");v1.playbackRate=2.0;')
    } else {
        b$Runtime$evaluate('var v1=document.querySelector("video");v1.playbackRate=1.0;')
    }
    NULL
}
is_video_finished <- function(b) {
    x=b$Runtime$evaluate('var v1=document.querySelector("video");v1.ended;')
    x$result$value
}
exitBrowser <- function(b) {
  invisible(b$close())
}

# ---- Main ----
run <- function() {
    #arguments
    link=args[1]
    if(length(args)==1) {
        faster=TRUE
    } else {
        if(as.numeric(args[2])==0) {
            faster=FALSE
        } else {
            faster=TRUE
        }
    }
    #
    b=createBrowser()
    visitLink(b,link)
    set_playBackRate(b,faster)
    code1="#root > div > div > div > div > div > div > div > div.TagItemLayout_wrap_1tXSl > a:nth-child(1) > span"
    ode2="#root > div > div > div > div > div > div > div > div.TagItemLayout_wrap_1tXSl > a:nth-child(2) > span"
    result1=extractData(b,code1) #view
    result2=extractData(b,code2) #like
    profile_fname=sprint("[profile]%s.csv",link)
    write.csv(data.frame(
        link=link,
        view=gsub(',','',result1),
        like=gsub(',','',result2)
    ),profile_fname,row.names=FALSE)
    cat("Ouptut:",profile_fname,"\n")
    comments=getComments(b,waitFor=60*1000,TRUE)
    comments=bind_rows(comments) %>%    
        distinct() %>%
        group_by(user,comment) %>%
        summarize(numOfDup=n()) %>%
        ungroup() %>%
        mutate(link=link)
    comment_fname=sprintf("[comment]%s.csv",link)
    write.csv(comments,comment_fname,row.names=FALSE)
    cat("Output:",comment_fname,"\n")
    exitBrowser(b)
    cat("Bye.")
}
run()