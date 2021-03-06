\name{delaunay}
\alias{delaunay}
\title{Delaunay Triangulation of Point Pattern}
\description{
  Computes the Delaunay triangulation of a spatial point pattern.
}
\usage{
delaunay(X)
}
\arguments{
  \item{X}{Spatial point pattern (object of class \code{"ppp"}).}
}
\details{
  The Delaunay triangulation of a spatial point pattern \code{X}
  is defined as follows. First the Dirichlet/Voronoi tessellation of \code{X}
  computed; see \code{\link{dirichlet}}. Then two points of \code{X}
  are defined to be Delaunay neighbours if their Dirichlet/Voronoi tiles
  share a common boundary. Every pair of Delaunay neighbours is
  joined by a straight line. The result is a tessellation, consisting of
  disjoint triangles. The union of these triangles is the convex hull of
  \code{X}.
}
\value{
  A tessellation (object of class \code{"tess"}). The window of the
  tessellation is the convex hull of \code{X}, not the original window
  of \code{X}.
}
\seealso{
  \code{\link{tess}},
  \code{\link{dirichlet}},
  \code{\link{convexhull.xy}},
  \code{\link{ppp}},
  \code{\link{delaunayDistance}},
  \code{\link{delaunayNetwork}}
}
\examples{
  X <- runifpoint(42)
  plot(delaunay(X))
  plot(X, add=TRUE)
}
\author{
Adrian Baddeley
\email{Adrian.Baddeley@uwa.edu.au}
\url{http://www.maths.uwa.edu.au/~adrian/}
Rolf Turner
\email{r.turner@auckland.ac.nz}
and Ege Rubak
\email{rubak@math.aau.dk}
}
\keyword{spatial}
\keyword{manip}
