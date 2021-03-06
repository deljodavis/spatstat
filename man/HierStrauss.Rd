\name{HierStrauss}
\alias{HierStrauss}
\title{The Hierarchical Strauss Point Process Model}
\description{
Creates an instance of the hierarchical Strauss point process model
which can then be fitted to point pattern data.
}
\usage{
  HierStrauss(radii, types=NULL, archy=NULL)
}
\arguments{
  \item{radii}{Matrix of interaction radii}
  \item{types}{Optional; vector of all possible types (i.e. the possible levels
    of the \code{marks} variable in the data)}
  \item{archy}{Optional: the hierarchical order. See Details.}
}
\value{
  An object of class \code{"interact"}
  describing the interpoint interaction
  structure of the hierarchical Strauss process with
  interaction radii \eqn{radii[i,j]}.
}
\details{
  This is a hierarchical point process model
  for a multitype point pattern
  (\ifelse{latex}{\out{H{\"o}gmander}}{Hogmander} and 
  \ifelse{latex}{\out{S{\"a}rkk{\"a}}}{Sarkka}, 1999;
  Grabarnik and \ifelse{latex}{\out{S\"{a}rkk\"{a}}}{Sarkka}, 2009).
  It is appropriate for analysing multitype point pattern data
  in which the types are ordered so that
  the points of type \eqn{j} depend on the points of type
  \eqn{1,2,\ldots,j-1}{1,2,...,j-1}.
  
  The hierarchical version of the (stationary) 
  Strauss process with \eqn{m} types, with interaction radii
  \eqn{r_{ij}}{r[i,j]} and 
  parameters \eqn{\beta_j}{beta[j]} and \eqn{\gamma_{ij}}{gamma[i,j]}
  is a point process
  in which each point of type \eqn{j}
  contributes a factor \eqn{\beta_j}{beta[j]} to the 
  probability density of the point pattern, and a pair of points
  of types \eqn{i} and \eqn{j} closer than \eqn{r_{ij}}{r[i,j]}
  units apart contributes a factor
  \eqn{\gamma_{ij}}{gamma[i,j]} to the density
  \bold{provided} \eqn{i \le j}{i <= j}. 
  
  The nonstationary hierarchical Strauss process is similar except that 
  the contribution of each individual point \eqn{x_i}{x[i]}
  is a function \eqn{\beta(x_i)}{beta(x[i])}
  of location and type, rather than a constant beta. 
 
  The function \code{\link{ppm}()},
  which fits point process models to 
  point pattern data, requires an argument 
  of class \code{"interact"} describing the interpoint interaction
  structure of the model to be fitted. 
  The appropriate description of the hierarchical
  Strauss process pairwise interaction is
  yielded by the function \code{HierStrauss()}. See the examples below.

  The argument \code{types} need not be specified in normal use.
  It will be determined automatically from the point pattern data set
  to which the HierStrauss interaction is applied,
  when the user calls \code{\link{ppm}}. 
  However, the user should be confident that
  the ordering of types in the dataset corresponds to the ordering of
  rows and columns in the matrix \code{radii}.

  The argument \code{archy} can be used to specify a hierarchical
  ordering of the types. It can be either a vector of integers
  or a character vector matching the possible types.
  The default is the sequence
  \eqn{1,2, \ldots, m}{1,2, ..., m} meaning that type \eqn{j}
  depends on types \eqn{1,2, \ldots, j-1}{1,2, ..., j-1}.
  
  The matrix \code{radii} must be symmetric, with entries
  which are either positive numbers or \code{NA}. 
  A value of \code{NA} indicates that no interaction term should be included
  for this combination of types.
  
  Note that only the interaction radii are
  specified in \code{HierStrauss}.  The canonical
  parameters \eqn{\log(\beta_j)}{log(beta[j])} and
  \eqn{\log(\gamma_{ij})}{log(gamma[i,j])} are estimated by
  \code{\link{ppm}()}, not fixed in \code{HierStrauss()}.
}
\seealso{
  \code{\link{MultiStrauss}} for the corresponding
  symmetrical interaction.

  \code{\link{HierHard}},
  \code{\link{HierStraussHard}}.
}
\examples{
   r <- matrix(10 * c(3,4,4,3), nrow=2,ncol=2)
   HierStrauss(r)
   # prints a sensible description of itself
   ppm(ants ~1, HierStrauss(r, , c("Messor", "Cataglyphis")))
   # fit the stationary hierarchical Strauss process to ants data
}
\author{Adrian Baddeley
  \email{Adrian.Baddeley@uwa.edu.au}
  \url{http://www.maths.uwa.edu.au/~adrian/},
  Rolf Turner
  \email{r.turner@auckland.ac.nz}
  and Ege Rubak.
}
\references{
  Grabarnik, P. and \ifelse{latex}{\out{S\"{a}rkk\"{a}}}{Sarkka}, A. (2009)
  Modelling the spatial structure of forest stands by
  multivariate point processes with hierarchical interactions.
  \emph{Ecological Modelling} \bold{220}, 1232--1240.

  \ifelse{latex}{\out{H{\"o}gmander}}{Hogmander}, H. and 
  \ifelse{latex}{\out{S{\"a}rkk{\"a}}}{Sarkka}, A. (1999)
  Multitype spatial point patterns with hierarchical interactions.
  \emph{Biometrics} \bold{55}, 1051--1058.
}
\keyword{spatial}
\keyword{models}
