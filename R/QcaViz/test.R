library(plotly)

journalist <- c(75,70,75,5,10,10,20,10,15,10,20)
developer <- c(25,10,20,60,80,90,70,20,5,10,10)
designer <- c(0,20,5,35,10,0,10,70,80,80,70)
label <- c('point 1','point 2','point 3','point 4','point 5','point 6',
           'point 7','point 8','point 9','point 10','point 11')


df <- data.frame(journalist,developer,designer,label)

# axis layout
axis <- function(title) {
  list(
    title = title,
    titlefont = list(
      size = 20
    ),
    tickfont = list(
      size = 15
    ),
    tickcolor = 'rgba(0,0,0,0)',
    ticklen = 5
  )
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
        aaxis = axis(labs[1]), #'자주성'
        baxis = axis(labs[2]'), #경제성'
        caxis = axis(labs[3]) #'세계화'
      ),
      margin=list(
        l=50,r=50,b=50,t=50,p=10
      )
    )
}