\name{close_connection}
\alias{close_connection}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Close connection
}
\description{
데이터 베이스 연결을 끊는다.
}
\usage{
close_connection(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{con}{
open_connectoin()으로 생성한 객체
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
김태경
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
open_connection()
}
\examples{
con <- open_connection()
mytable <- con %>% tbl("someTable") %>% collect()
close_connection(con)
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
