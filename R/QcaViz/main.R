
# Prep --------------------------------------------------------------------
load('df1.RData') #누적
load('df2.RData') #영업이익률
load('df3.RData') #전년대비 실질 매출액 증가율
source('fsQcaViz.R') #시각화 
#installKorFont() #한글 문제 해결
# Plot --------------------------------------------------------------------

plotArea(df1,c('자주성','경제성','세계화'))
plotArea(df1,c('자주성','경제성','세계화'),note1='2002',note2='2004')
plotArea(df1,c('자주성','경제성','세계화'),note1='2004',note2='2008')
plotArea(df1,c('자주성','경제성','세계화'),note1='2008',note2='2012')

plotTrend(df2,"영업이익률")
plotTrend(df3,"전년대비 실질 매출액 증가율")
