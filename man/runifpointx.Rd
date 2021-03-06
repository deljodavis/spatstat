\name{runifpointx}
\alias{runifpointx}
\title{
  Generate N Uniform Random Points in Any Dimensions
}
\description{
  Generate a random point pattern containing \code{n}
  independent, uniform random points in any number of spatial dimensions.
}
\usage{
runifpointx(n, domain, nsim=1)
}
\arguments{
  \item{n}{
    Number of points to be generated.
  }
  \item{domain}{
    Multi-dimensional box in which the process should be generated.
    An object of class \code{"boxx"}.
  }
  \item{nsim}{Number of simulated realisations to be generated.}
}
\value{
  If \code{nsim = 1}, a point pattern (an object of class \code{"ppx"}).
  If \code{nsim > 1}, a list of such point patterns.
}
\details{
  This function generates a pattern of \code{n} independent random points,
  uniformly distributed in the multi-dimensional box \code{domain}.
}
\seealso{
  \code{\link{rpoisppx}}, 
  \code{\link{ppx}}, 
  \code{\link{boxx}}
}
\examples{
   w <- boxx(x=c(0,1), y=c(0,1), z=c(0,1), t=c(0,3))
   X <- runifpointx(50, w)
}
\author{Adrian Baddeley
  \email{Adrian.Baddeley@uwa.edu.au}
  \url{http://www.maths.uwa.edu.au/~adrian/}
  and Rolf Turner
  \email{r.turner@auckland.ac.nz}
}
\keyword{spatial}
\keyword{datagen}
