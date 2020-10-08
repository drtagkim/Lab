# Introduction
- Maintainer: Taekyung Kim, PhD., Associate Professor, Kwangwoon University
- Collaborator: Dongwon Lee, PhD., Professor, Korea University

# Install
## R
* Install R: R>=3.5.2 (recommendation: >=4.0.2)
* Intall Rtools (See also, CRAN) https://cran.r-project.org/bin/windows/Rtools/

## How to Install Rflixpatrol

Make sure that you have installed the latest R(>=4.0.2) and the following packages: tidyverse, rvest, remotes. If you do not have those, execute the following codes to install dependenceis:

```
install.packages("tidyverse")
install.packages("rvest")
install.packages("remotes")
```

To install Rflixpatrol, run the following:

```
remotes::install_github("drtagkim/Lab/R/Rflixpatrol")
```

# Code Example

```{r}
library(Rflixpatrol)
y2020m08netflix <- collect_chart('netflix','2020-08-31',3)
```

Or,

```
y2020m08netflix <- collect_chart('netflix',datecode='2020-08-31',days=3,tout=120)
```
Parameters: streaming site code, time to start, time lag(days), timeout(seconds)

How to set up 'days': If you need data from 2020/08/01 to 2020/08/31, set datecode='2020-08-31' and days=30. If you want to collect data from 2020/09/01 to 2020/09/30, set datecode='2020-09-30' and days=29.

You can set up a different region parameter by 'locale.' For example, use 'united-states' as a locale value. Notice that 'collect_chart_locale()' is called. 

```
y2020m08netflix_us <- collect_chart_locale('netflix',datecode='2020-08-31',locale='united-states',days=3)
```

See also, streaming_locales to find out other locale codes ($streamer).

```
> View(streaming_locales)
# A tibble: 88 x 2
   streamer   address                                          
   <chr>      <chr>                                            
 1 world      https://flixpatrol.com/top10/streaming/world     
 2 argentina  https://flixpatrol.com/top10/streaming/argentina 
 3 australia  https://flixpatrol.com/top10/streaming/australia 
 4 austria    https://flixpatrol.com/top10/streaming/austria   
 5 bangladesh https://flixpatrol.com/top10/streaming/bangladesh
 6 belarus    https://flixpatrol.com/top10/streaming/belarus   
 7 belgium    https://flixpatrol.com/top10/streaming/belgium   
 8 bolivia    https://flixpatrol.com/top10/streaming/bolivia   
 9 brazil     https://flixpatrol.com/top10/streaming/brazil    
10 bulgaria   https://flixpatrol.com/top10/streaming/bulgaria 

> View(streaming_sites)
# A tibble: 11 x 2
   streamer  address                               
   <chr>     <chr>                                 
 1 streaming https://flixpatrol.com/top10/streaming
 2 amazon    https://flixpatrol.com/top10/amazon   
 3 disney    https://flixpatrol.com/top10/disney   
 4 fandango  https://flixpatrol.com/top10/fandango 
 5 google    https://flixpatrol.com/top10/google   
 6 hbo       https://flixpatrol.com/top10/hbo      
 7 hulu      https://flixpatrol.com/top10/hulu     
 8 imdb      https://flixpatrol.com/top10/imdb     
 9 itunes    https://flixpatrol.com/top10/itunes   
10 netflix   https://flixpatrol.com/top10/netflix  
11 vudu      https://flixpatrol.com/top10/vudu

```

```
netflix_data<-harvest_chart(y2020m08netflix,'netflix')
export_csv(netflix_data,'netflix_data.csv')
#Or
netflix_data2<-harvest_chart_locale(y2020m08netflix_us,'netflix')
export_csv(netflix_data2,'netflix_data_us.csv')
```

# Development Note
* [2020-10-03] Chart 데이터 받기(raw data)

# TODOs
- [x] 최근 3개월(9,8,7월) 데이터 시험 수집(netflix, amazon, google)
- [x] 후처리를 위한 검정 코드 작성
- [x] TSV나 Excel로 데이터 export 코드 작성
- [x] RQ는 뭘까?
- [x] Update 내용 반영
- [x] 개별 아이템에 관한 정보 취득

# Rflixpatrol 관련 정보
* 2020년 7월 이후 데이터 괜찮고, 이전 데이터는 별로...
* 2020년 3월 1일 이후부터 데이터 기록.