% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/freqresp.R
\name{freqresp}
\alias{freqresp}
\title{Low level frequency response function}
\usage{
freqresp(sys, w = seq(0, 100, length = 10000), iu = 1)
}
\arguments{
\item{sys}{An LTI system of \code{tf}, \code{ss} and \code{zpk} class}

\item{w}{a vector of frequency points}

\item{iu}{For calls to \code{freqresp}, \code{iu} is a number specifying an input for a MIMO state-space system. If the system has
3 inputs, then \code{iu} would be set to 1, set to 2 and then to 3 to obtain the step
response from input 1, 2, and 3 to the outputs}
}
\value{
\code{freqresp(sys, w)} returns a vector of frequencies for \code{sys} in complex form
}
\description{
This function obtains the low level frequency response of a system.
}
\examples{
H <- freqresp(ssdata(tf(c(1,1), c(1,2,1))), (seq(0, 100, length = 10000)))
H <- freqresp(tf(c(1,1), c(1,2,1)), seq(0, 100, length = 10000))

}
\seealso{
\code{\link{bode}} \code{\link{nyquist}}
}
