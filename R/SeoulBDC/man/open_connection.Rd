\name{open_connection}
\alias{open_connection}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Open MySQL connection
}
\description{
MySQL 연결을 연다.
}
\usage{
open_connection()

open_connection(dbname='bigdata')
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{dbname}{(optional) 디폴트는 bigdata이지만, 사용자가 다른 데이터베이스를 지정할 수 있다.
%%     ~~Describe \code{x} here~~
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
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
con <- open_connection()
mytable <- con %>% tbl("someTable") %>% collect()
close_connection(con)
}
