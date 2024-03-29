\name{line graph}
\alias{line graph}

\title{Line graph}
\examples{
line_example1 <- function() {
  ggplot(data=dat, aes(x=time, y=total_bill, group=1)) +
    geom_line()
}

line_example2 <- function() {
  ggplot(data=dat, aes(x=time, y=total_bill, group=1)) +
    geom_line() +
    geom_point()
}

line_example3 <- function() {
  ggplot(data=dat, aes(x=time, y=total_bill, group=1)) +
    geom_line(colour="red", linetype="dashed", size=1.5) +
    geom_point(colour="red", size=4, shape=21, fill="white")
}

line_example4 <- function() {
  ggplot(data=dat, aes(x=time, y=total_bill, group=1)) +
    geom_line() +
    geom_point() +
    expand_limits(y=0) +
    xlab("Time of day") + ylab("Total bill") +
    ggtitle("Average bill for 2 people")
}

line_example5 <- function() {
  # Basic line graph with points
  ggplot(data=dat1, aes(x=time, y=total_bill, group=sex)) +
    geom_line() +
    geom_point()
}
line_example6 <- function() {
  # Map sex to color
  ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, colour=sex)) +
    geom_line() +
    geom_point()

}
line_example7 <- function() {
  # Map sex to different point shape, and use larger points
  ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, shape=sex)) +
    geom_line() +
    geom_point()
}
line_example8 <- function() {
  # Use thicker lines and larger points, and hollow white-filled points
  ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, shape=sex)) +
    geom_line(size=1.5) +
    geom_point(size=3, fill="white") +
    scale_shape_manual(values=c(22,21))
}
line_example9 <- function() {
  ggplot(data=dat1, aes(x=sex, y=total_bill, group=time, shape=time, color=time)) +
    geom_line() +
    geom_point()
}
line_example10 <- function() {
  # A line graph
  ggplot(data=dat1, aes(x=time, y=total_bill, group=sex, shape=sex, colour=sex)) +
    geom_line(aes(linetype=sex), size=1) +     # Set linetype by sex
    geom_point(size=3, fill="white") +         # Use larger points, fill with white
    expand_limits(y=0) +                       # Set y range to include 0
    scale_colour_hue(name="Sex of payer",      # Set legend title
                     l=30)  +                  # Use darker colors (lightness=30)
    scale_shape_manual(name="Sex of payer",
                       values=c(22,21)) +      # Use points with a fill color
    scale_linetype_discrete(name="Sex of payer") +
    xlab("Time of day") + ylab("Total bill") + # Set axis labels
    ggtitle("Average bill for 2 people") +     # Set title
    theme_bw() +
    theme(legend.position=c(.7, .4))           # Position legend inside
  # This must go after theme_bw
}
line_example11 <- function() {
  ggplot(data=datn, aes(x=dose, y=length, group=supp, colour=supp)) +
    geom_line() +
    geom_point()
}
line_example12 <- function() {
  datn2 <- datn
  datn2$dose <- factor(datn2$dose)
  ggplot(data=datn2, aes(x=dose, y=length, group=supp, colour=supp)) +
      geom_line() +
      geom_point()
}
line_example13 <- function() {
  # Use the original data frame, but put factor() directly in the plot specification
  ggplot(data=datn, aes(x=factor(dose), y=length, group=supp, colour=supp)) +
    geom_line() +
    geom_point()
}

}
