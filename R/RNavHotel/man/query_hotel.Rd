\name{query_hotel}
\alias{query_hotel}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Query Hotel Data
}
\description{
Query hotel data
}
\usage{
query_hotel(hotel_key,target_date)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{hotel_key}{
  Hotel key url, e.g., https://hotel.naver.com/hotels/item?hotelId=hotel:Shilla_Stay_Gwanghwamun&checkin=2020-11-04&checkout=2020-11-06&rooms=2 -> key: Shilla_Stay_Gwanghwamun
}
  \item{target_date}{
  The date when you want to stay (for two days, as default)
  }
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
An object for database processing (SQLite). See, update_data_sqlite(dt,filename)
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
Use HeidiSQL(>=11.0) for viewing an SQLite file.
}
\examples{
hotel_key='Nine_Tree_Premier_Hotel_Insadong'
target_date='2020-11-01'
test=query_hotel(hotel_key,target_date)
#database
update_data_sqlite(test,'test.db')
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
