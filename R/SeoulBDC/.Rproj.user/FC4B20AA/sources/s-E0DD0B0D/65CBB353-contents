\name{table_name_contains}
\alias{table_name_contains}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Get table names containing a keyword
}
\description{
정규식 문자 패턴을 따르는 테이블 이름 가져오기
}
\usage{
table_name_contains(con, name_part)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{con}{
%%     ~~Describe \code{con} here~~
}
  \item{name_part}{
%%     ~~Describe \code{name_part} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
테이블 이름 문자 벡터
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (con, name_part)
{
    tables = list_tables(con)
    str_detect(tables, regex(name_part, ignore_case = TRUE))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
