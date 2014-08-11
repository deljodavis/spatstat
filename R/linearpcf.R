#
# linearpcf.R
#
# $Revision: 1.8 $ $Date: 2011/07/21 08:01:37 $
#
# pair correlation function for point pattern on linear network
#
#
linearpcf <- function(X, r=NULL, ..., correction="Ang") {
  stopifnot(inherits(X, "lpp"))
  correction <- pickoption("correction", correction,
                           c(none="none",
                             Ang="Ang",
                             best="Ang"),
                           multi=FALSE)
  # extract info about pattern
  sX <- summary(X)
  np <- sX$npoints
  lengthL <- sX$totlength
  # compute
  denom <- np * (np - 1)/lengthL
  g <- linearpcfengine(X, r=r, ..., denom=denom, correction=correction)
  # set appropriate y axis label
  switch(correction,
         Ang  = {
           ylab <- quote(g[L](r))
           fname <- "g[L]"
         },
         none = {
           ylab <- quote(g[net](r))
           fname <- "g[net]"
         })
  g <- rebadge.fv(g, new.ylab=ylab, new.fname=fname)
  return(g)
}

linearpcfinhom <- function(X, lambda=NULL, r=NULL,  ...,
                           correction="Ang", normalise=TRUE) {
  stopifnot(inherits(X, "lpp"))
  correction <- pickoption("correction", correction,
                           c(none="none",
                             Ang="Ang",
                             best="Ang"),
                           multi=FALSE)
  if(is.null(lambda))
    linearpcf(X, r=r, ..., correction=correction)
  # extract info about pattern
  sX <- summary(X)
  np <- sX$npoints
  lengthL <- sX$totlength
  #
  XX <- as.ppp(X)
  lambdaX <-
    if(is.vector(lambda)) lambda  else
    if(is.function(lambda)) lambda(XX$x, XX$y, ...) else
    if(is.im(lambda)) safelookup(lambda, XX) else 
    if(is.ppm(lambda) || inherits(lambda, "lppm"))
      predict(lambda, locations=as.data.frame(XX)) else
    stop("lambda should be a numeric vector, function, image or ppm object")

  if(!is.numeric(lambdaX))
    stop("Values of lambda are not numeric")
  if((nv <- length(lambdaX)) != np)
     stop(paste("Obtained", nv, "values of lambda",
	   "but point pattern contains", np, "points"))
  if(any(lambdaX < 0))
    stop("Negative values of lambda obtained")
  if(any(lambdaX == 0))
    stop("Zero values of lambda obtained")

  invlam <- 1/lambdaX
  invlam2 <- outer(invlam, invlam, "*")
  denom <- if(!normalise) lengthL else sum(invlam)
  g <- linearpcfengine(X, ..., r=r,
                       reweight=invlam2, denom=denom, correction=correction)
  # extract bandwidth
  bw <- attr(g, "bw")
  # set appropriate y axis label
  switch(correction,
         Ang  = {
           ylab <- quote(g[LI](r))
           fname <- "g[LI]"
         },
         none = {
           ylab <- quote(g[netI](r))
           fname <- "g[netI]"
         })
  g <- rebadge.fv(g, new.fname=fname, new.ylab=ylab)
  # reattach bandwidth
  attr(g, "bw") <- bw
  return(g)
}


linearpcfengine <- function(X, ..., r=NULL,
                            reweight=NULL, denom=1, correction="Ang") {
  # extract info about pattern
  sX <- summary(X)
  np <- sX$npoints
  lengthL <- sX$totlength
  # extract linear network
  L <- X$domain
  # extract points
  Y <- as.ppp(X)
  W <- Y$window
  # determine r values
  rmaxdefault <- 0.98 * circumradius(L)
  breaks <- handle.r.b.args(r, NULL, W, rmaxdefault=rmaxdefault)
  r <- breaks$r
  rmax <- breaks$max
  #
  if(np < 2) {
    # no pairs to count: return zero function
    zeroes <- rep(0, length(r))
    df <- data.frame(r = r, est = zeroes)
    g <- fv(df, "r", substitute(linearpcf(r), NULL),
            "est", . ~ r, c(0, rmax),
            c("r", "%s(r)"),
            c("distance argument r", "estimated %s"),
            fname = "linearpcf")
    return(g)
  }
  # compute pairwise distances  
  D <- pairdist(X)
  #---  compile into pcf ---
  if(correction == "none" && is.null(reweight)) {
    # no weights (Okabe-Yamada)
    g <- compilepcf(D, r, denom=denom)
    unitname(g) <- unitname(X)
    return(g)
  }
  if(correction == "none")
     edgewt <- 1
  else {
     # inverse m weights (Wei's correction)
     # compute m[i,j]
     m <- matrix(1, np, np)
     for(j in 1:np) 
       m[ -j, j] <- countends(L, Y[-j], D[-j,j])
     edgewt <- 1/m
  }
  # compute pcf
  wt <- if(!is.null(reweight)) edgewt * reweight else edgewt
  g <- compilepcf(D, r, weights=wt, denom=denom, ...)
  # extract bandwidth
  bw <- attr(g, "bw")
  # tack on theoretical value
  g <- bind.fv(g, data.frame(theo=rep(1,length(r))), "%s[theo](r)",
               "theoretical Poisson %s")
  # tweak
  g <- rebadge.fv(g, new.fname="linearpcfengine")
  unitname(g) <- unitname(X)
  fvnames(g, ".") <- rev(fvnames(g, "."))
  # tack on bandwidth again
  attr(g, "bw") <- bw
  return(g)
}
