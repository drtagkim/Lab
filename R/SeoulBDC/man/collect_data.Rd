\name{collect_data}
\alias{collect_data}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Collect data from a table
}
\description{
테이블에서 데이터를 가져온다.
}
\usage{
collect_data(con, table_name)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{con}{
접속 개체, open_connection() 참고
}
  \item{table_name}{
가져올 테이블의 이름
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
data.frame 데이터
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
function (con, table_name)
{
    con \%>\% tbl(table_name) \%>\% collect()
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
