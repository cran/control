#' @title Closed Feedback Loops
#'
#' @usage cloop(sys, e, f)
#
#'
#' @description
#' \code{cloop} forms a closed feedback loop for a state-space or transfer function system
#'
#'
#' @details
#' Other possible usages of \code{cloop}:
#'
#' \code{cloop(sys)}
#'
#' \code{cloop(sys, sgn)}
#'
#' If \code{sys} is a state-space model,  \code{cloop(sys, SGN)} produces a state-space model
#'	of the closed-loop system obtained by feeding all the outputs of
#'	the system to all the inputs.  Positive feedback is used when SGN <- 1 and negative
#' when SGN <- -1
#'
#' If \code{sys} is a transfer function model, \code{cloop(sys, SGN)}
#' produces the SISO closed loop
#'	system in transfer function form obtained by unity feedback with
#'	the sign SGN.
#'
#' cloop(sys,OUTPUTS,INPUTS) forms the closed
#'	loop system obtained by feeding the specific outputs into
#' specific outputs.  The vectors \code{OUTPUTS} and \code{INPUTS} contain indices
#'	into the outputs and inputs of the system respectively.  Positive
#'	feedback is assumed. To form closed loop with negative feedback, negative	values are used in the vector \code{INPUTS}.
#'
#'
#' @param sys   LTI system model of transfer-function or state-space model
#' @param e     inputs vector
#' @param f     outputs vector
#'
#' @return Returns a closed feedback loop system
#'
#' @seealso \code{\link{feedback}}
#'
#' @examples
#' J <- 2.0; b <- 0.04; K <- 1.0; R <- 0.08; L <- 1e-4
#' P <- TF("K/(s*((J*s + b)*(L*s + R) + K^2))")
#' cloop(P)
#' cloop(ss(1,2,3,4))
#' @export

cloop <- function(sys, e, f){

  if (class(sys) == 'tf') {
    if (nargs() == 1) {
      tfsys <- tfchk(sys$num, sys$den)
      num <- tfsys$numc
      den <- tfsys$denc
      sgn <- -1
    } else if (nargs() == 2) {
      # transfer function with sign on feedback
      tfsys <- tfchk(sys$num, sys$den)
      num <- tfsys$numc
      den <- tfsys$denc
      sgn <- e  # changed from sgn <- sign(e) to sgn <- e
    }
    ac <- num
    bc <- den - sgn * num
    return( tf(ac, bc) )
  }

  if (class(sys) == 'zpk') {
    sys_Zpk2SS <- ssdata(sys)
  }
  if (class(sys) == 'ss' || exists("sys_Zpk2SS"))  {
    if (exists("sys_Zpk2SS")) {
      sys <- sys_Zpk2SS
    }
   errmsg <- abcdchk(sys)
    if (errmsg != "") {
      stop(errmsg)
    }
    a <- sys[[1]]
    b <- sys[[2]]
    c <- sys[[3]]
    d <- sys[[4]]

    d_rows <- nrow(d)
    d_cols<- ncol(d)
    if (nargs() == 1) {
      # Assume negative feedback for sys without sign
      outputs <- 1:d_rows
      inputs  <- 1:d_cols
      sgn <- -matrix(rep(1, length(inputs)), 1, length(inputs))
    }
    if (nargs() == 2) {
      # sys with sign
      outputs <- 1:d_rows
      inputs  <- 1:d_cols
      sgn <- e * matrix(rep(1, length(inputs)), 1, length(inputs))
    }
    if (nargs() == 3) {
      # sys with selection vectors
      outputs <- e
      inputs <- abs(f)
      sgn <- sign(f)
    }
    num_inputs  <- length(inputs)
    num_outputs <- length(outputs)
    a_rows <- nrow(a)
    a_cols <- ncol(a)
    # Form Closed Loop State-space System
    if (num_inputs != num_outputs) {
      stop("The number of feedback inputs and outputs are not equal")
    }
    ssys  <- rbind(cbind(a, b), cbind(c, d))
    Binp <- ssys[ , (a_rows + inputs), drop = FALSE]
    Cout <- ssys[(a_rows + outputs), , drop = FALSE]
    if (!is.null(Cout)) {
      for (i in 1:length(sgn)) {
        if (sgn[i] == -1) {
          Cout[i, ] <- -Cout[i, ]
        } else {
          Cout[i, ] <- sgn[i] * Cout[i, ]
        }
      }
      E <- diag(1, num_outputs, num_outputs) - Cout[ , (a_rows + inputs), drop = FALSE]
      Cout <- solve(E, Cout)
      clp_s <- ssys + Binp %*% Cout
      a_Clp <- clp_s[1:a_rows, 1:a_rows]
      b_Clp <- clp_s[1:a_rows, (a_rows + 1):(a_rows + d_cols)]
      c_Clp <- clp_s[(a_rows + 1):(a_rows + d_rows), 1:a_rows]
      d_Clp <- clp_s[(a_rows + 1):(a_rows + d_rows), (a_rows + 1):(a_rows + d_cols)]
    }  else{
      a_Clp <- a
      b_Clp <- b
      c_Clp <- c
      d_Clp <- d
    }
    return(ss(a_Clp, b_Clp, c_Clp, d_Clp))
  }

}
