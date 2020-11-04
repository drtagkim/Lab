\name{run_to_sqlite}
\alias{run_to_sqlite}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Collect Data and Export to SQLite3 Database
}
\description{
Main function...
}
\usage{
run_to_sqlite(x)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{database name}{
  default: test.db. You can set the name as you want. Make sure that the file name ends with the extension, '.db'.
}
}
\details{
I strongly recommend installing HeidiSQL, a nice SQL workbench mainly focusing MariaDB. From the version of 11, HeidiSQL supports SQLite3 although it is a beta version. There is no problem so far. Visit https://www.heidisql.com/ to get HeidiSQL. If you are not sure about how to use SQL, visit W3School SQL Tutorial for quick learning. See also, https://www.w3schools.com/sql/ .
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
Taekyung Kim, PhD.
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
 run_to_sqlite('testdb.db')
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
