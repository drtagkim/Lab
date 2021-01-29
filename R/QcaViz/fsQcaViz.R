
# Util --------------------------------------------------------------------


reqPkg <- function(PKG) {
  REPO="https://cran.rstudio.com"
  suppressMessages({
    if(!require(PKG,character.only=TRUE,quietly=TRUE)) install.packages(PKG,repos=REPO,quiet=TRUE)
    require(PKG,character.only=TRUE,quietly=TRUE)
  })
}
installKorFont <- function() {
  reqPkg('ggplot2')
  install.packages("extrafont")
  library(extrafont)
  font_import()
}

# Plot --------------------------------------------------------------------


plotArea <- function(df,field_name,title_text='fsQCA Visualization',...) {
  reqPkg('dplyr')
  reqPkg('tidyr')
  reqPkg('ggplot2')
  names(df)[1]='year'
  #names(df)[2:4]=field_name
  g=df %>%
    gather(2:4,key='COL',value='VAL') %>%
    group_by(year)%>%
    mutate(VALP=VAL/sum(VAL)*100) %>%
    ungroup() %>%
    ggplot(aes(x=factor(year),y=VALP,fill=COL,group=COL)) +
    geom_area(alpha=0.5,size=1,colour='black')+
    scale_fill_manual(values=c('blue','green','red'),labels=field_name[c(3,2,1)])+
    theme_bw()+
    theme(text=element_text(family='NanumGothic'))+
    theme(axis.text.x = element_text(angle=90))+
    ggtitle(title_text)+
    xlab("연도")+
    ylab("비중")+
    labs(fill='범주')
  opts=list(...)
  if('note1' %in% names(opts) && 'note2' %in% names(opts)) {
    g=g+annotate('rect',xmin=opts$note1,xmax=opts$note2,ymin=0,ymax=100,alpha=0.5)+
      geom_vline(xintercept=opts$note1,color='blue')+
      geom_vline(xintercept=opts$note2,color='red')
  }
  g
}
plotTrend <- function(df,y_label,...) {
  reqPkg("ggplot2")
  reqPkg("dplyr")
  names(df)=c('year','r','g','b','om')
  df %>%
    ggplot(aes(x=as.factor(year),y=om))+
    geom_point(size=10,shape=22,fill=rgb(df2$r/255,df2$g/255,df2$b/255))+
    geom_line(group=1)+
    theme_bw()+
    theme(text=element_text(family='NanumGothic'))+
    theme(axis.text.x = element_text(angle=90))+
    ggtitle("")+
    xlab("연도")+
    ylab(y_label)
}
plotTernary <- function(df,year_from,year_to,labs) {
  reqPkg("plotly")
  df<-df %>%
    filter(year%in%c(year_from,year_to))
  names(df)[2]='RED'
  names(df)[3]='GREEN'
  names(df)[4]='BLUE'
  df$col=rgb(df$RED/255,df$GREEN/255,df$BLUE/255)
  fig <- df %>% plot_ly() %>%
    add_trace(
      type = 'scatterternary',
      mode = 'markers',
      a = ~RED,
      b = ~GREEN,
      c = ~BLUE,
      text = ~year,
      marker = list( 
        symbol = c("circle","diamond"),
        size = 40,
        color=df$col,
        line = list('width' = 0)
      )
    ) %>% layout(
      title = "",
      ternary = list(
        sum = 100,
        aaxis = axis(labs[1]),#자주성
        baxis = axis(labs[2]), #경제성
        caxis = axis(labs[3]) #세계화
        ),
        margin=list(
          l=50,r=50,b=50,t=50,p=10
        )
      )
  fig
}
