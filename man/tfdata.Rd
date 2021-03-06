% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tfdata.R
\name{tfdata}
\alias{tfdata}
\title{Retrieve Transfer function data}
\usage{
tfdata(sys1)
}
\arguments{
\item{sys1}{an LTI system object of tf, ss or zpk classes}
}
\value{
Returns a list object of \code{tf} class containing numerator and denominator coefficients in desecending values of s.
 For multiple-input multiple-output systems (MIMO) a list containing tf sys objects for as many outputs is returned
}
\description{
\code{tfdata} retrieves the model for a transfer function from a \code{sys} object
}
\details{
\code{tfdata} retrieves a model object for a transfer function, from a \code{sys} object of tf, ss and zpk classes
}
\examples{
sys1 <- zpk(NULL, c(-1,-1), 1)
tfdata(sys1)
A <- rbind(c(-2, -1), c(1,0)); B <- rbind(1,0);
C <- cbind(0,1); D <- 0
tfdata( ss(A, B, C, D) )
tfdata(ss2zp( A,B,C,D))
tfdata(tf(c(1), c(1,2,1)))

 \dontrun{  MIMO system }
A = rbind(c(0,1), c(-25,-4)); B = rbind(c(1,1), c(0,1));
C = rbind(c(1,0), c(0,1)); D = rbind(c(0,0), c(0,0))
tfdata(ss(A,B,C,D))

}
\seealso{
\code{\link{tf}} \code{\link{ssdata}} \code{\link{zpkdata}}
}
