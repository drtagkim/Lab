#Traveling Salesman Problem
install.packages("TSP")
#
library(TSP)
city<-c('서울','원주','대전','광주','부산')
x<-c(2.8,5.0,3.8,2.5,7.7)
y<-c(8.8,8.0,5.2,1.8,1.8)
locations<-data.frame(x,y)
plot(x,y,xlim=c(0,10),ylim=c(0,10),pch=19,cex=1.5,col='red')
text(x,y,labels=city,pos=3)
#
etsp<-ETSP(locations)
tour<-solve_TSP(etsp)
tour_length(tour)
city[as.integer(tour)]
#
polygon(x[as.integer(tour)],y[as.integer(tour)])
