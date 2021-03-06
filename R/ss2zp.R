#' @title State-space representation to zero-pole-gain representation
#'
#' @description
#' \code{ss2zp} converts a system represented in state-space form to zero-pole-gain model
#'
#' @usage ss2zp(a,b,c,d,iu)
#'
#' @details
#' \code{ss2zp} converts a system represented in zero-pole form to state-space by converting from zero-pole to transfer function and from transfer functon to state-space
#' The vector P contains the pole locations of the denominator of the transfer function.
#'
#' Other possible usages for \code{ss2zp} are:
#'
#' \code{ss2zp(a,b,c,d)}
#'
#' \code{ss2zp(sys)}
#'
#' \code{ss2zp(sys, iu)}
#'
#' where \code{sys} is  an object of state-space class
#'
#' @param a An n x n matrix
#' @param b An n x m matrix
#' @param c An p x n matrix
#' @param d An p x m matrix
#' @param iu A numeric value denoting number of inputs. default value is 1.For example, if the system
#' has three inputs (u1, u2, u3), then iu must be either 1, 2, or 3, where 1 implies u1, 2
#' implies u2, and 3 implies u3.
#'
#' @return Returns a list object of 'zpk' class, consisting of z, p and k. The numerator zeros are returned in the columns of matrix Z with number of columns equal to number of outputs.  The gains for
#'  each numerator transfer function are returned in column vector K. P, a column vector contains the pole locations of the denominator of the transfer function.
#'
#' @seealso \code{\link{zp2ss}} \code{\link{ss2tf}}
#'
#' @examples
#' A <- rbind(c(-2, -1), c(1,0)); B <- rbind(1,0);
#' C <- cbind(0,1); D <- 0;
#' sys2 <- ss(A,B,C,D)
#' ss2zp(sys2$A,sys2$B,sys2$C,sys2$D)
#' ss2zp( zp2ss ( tf2zp( c(1,1,1), c(1,2,1) ) ) )
#'
#' \dontrun{  A MIMO system }
#' A = rbind(c(0,1), c(-25,-4)); B = rbind(c(1,1), c(0,1));
#' C = rbind(c(1,0), c(0,1)); D = rbind(c(0,0), c(0,0))
#' ss2tf(A,B,C,D,1) # to obtain output for input 1
#' ss2tf(A,B,C,D,2) # to obtain output for input 2
#'
#' \dontrun{  OR }
#'
#' systems <- vector("list", ncol(D))
#' for(i in 1:ncol(D)){ systems[[i]] <- ss2zp(A,B,C,D,i) }
#' systems
#' systems[[1]]
#' systems[[2]]
#'
#' @export
#

ss2zp <- function (a, b, c, d, iu = 1) {
  if (nargs() == 1 || nargs() == 2)  {
    sys_tmp <- a

    if (nargs() == 2){
      iu <- b
    }
    if( class(sys_tmp) == 'ss') {
      sys <- unclass(sys_tmp)
      a <- sys$A
      b <- sys$B
      c <- sys$C
      d <- sys$D

    } else {
      stop("SS2TF: sys should be a state-space model")
    }
  }

  sys_tf <- ss2tf(ss(a, b, c, d), iu)
  sys_zp <- tf2zp(sys_tf)
  return(sys_zp)
}
