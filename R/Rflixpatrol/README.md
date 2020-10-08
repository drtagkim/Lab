# 소개
- 담당: 김태경
- 연구: 이동원 교수(고려대), 김태경 교수(광원대)

# 개발노트
* [2020-10-03] Chart 데이터 받기(raw data)

# 설치
## R
* R은 3.5.0 이상(4.0.2 이상 권장)
* install.packages()로 설치해야 할 패키지: tidyverse, rvest, remotes
* Rtools 설치(CRAN 홈페이지 참고)

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

# 코드 예제

```{r}
library(Rflixpatrol)
y2020m08netflix <- collect_chart('netflix','2020-08-31',3)
```

Or,

```
y2020m08netflix <- collect_chart('netflix',datecode='2020-08-31',days=3,tout=120)
```
Parameters: streaming site code, time to start, time lag(days), timeout(seconds)

히스토리 지정 방법: 2020-08-31일부터 31일 포함하여 31개 날짜 가져온다면? 31-1=30. 만약 2020-09-30일부터 2020-09-01까지를 가져오려면? 30-1=29로 히스토리 지정해야 함.

저장된 y2020m08netflix는 list 객체. movie, tvshow로 구분. 모두 raw 데이터, 따라서 후처리 필요(별도 개발?).

# 개발 노트
- [x] 최근 3개월(9,8,7월) 데이터 시험 수집(netflix, amazon, google)
- [x] 후처리를 위한 검정 코드 작성
- [ ] TSV나 Excel로 데이터 export 코드 작성
- [x] RQ는 뭘까?
- [ ] Update 내용 반영
- [ ] 개별 아이템에 관한 정보 취득

# Rflixpatrol 관련 정보
* 2020년 7월 이후 데이터 괜찮고, 이전 데이터는 별로...
* 2020년 3월 1일 이후부터 데이터 기록.