#
#  dist2dpath.R
#
#   $Revision: 1.8 $    $Date: 2014/10/24 00:22:30 $
#
#       dist2dpath    compute shortest path distances
#

dist2dpath <- function(dist, method="C") {
  ## given a matrix of distances between adjacent vertices
  ## (value = Inf if not adjacent)
  ## compute the matrix of shortest path distances
  stopifnot(is.matrix(dist) && isSymmetric(dist))
  stopifnot(all(diag(dist) == 0))
  stopifnot(all(dist[is.finite(dist)] >= 0))
  ##
  n <- nrow(dist)
  if(n <= 1) return(dist)
  cols <- col(dist)
  ##
  shortest <- min(dist[is.finite(dist) & dist > 0])
  tol <- shortest/max(n,1024)
  tol <- max(tol, .Machine$double.eps)
  ##
  switch(method,
         interpreted={
           dpathnew <- dpath <- dist
           changed <- TRUE
           while(changed) {
             for(j in 1:n) 
               dpathnew[,j] <- apply(dpath + dist[j,][cols], 1, min)
             changed <- any(abs(dpathnew - dpath) > tol)
             dpath <- dpathnew
           }
         },
         C={
           adj <- is.finite(dist)
           diag(adj) <- TRUE
           d <- dist
           d[!adj] <- -1
           z <- .C("Ddist2dpath",
                   nv=as.integer(n),
                   d=as.double(d),
                   adj=as.integer(adj),
                   dpath=as.double(numeric(n*n)),
                   tol=as.double(tol),
                   niter=as.integer(integer(1)),
                   status=as.integer(integer(1)))
           if(z$status == -1)
             warning(paste("C algorithm did not converge to tolerance", tol,
                           "after", z$niter, "iterations",
                           "on", n, "vertices and",
                           sum(adj) - n, "edges"))
           dpath <- matrix(z$dpath, n, n)
           ## value=-1 implies unreachable
           dpath[dpath < 0] <- Inf
         },
         stop(paste("Unrecognised method", sQuote(method))))
  return(dpath)
}
