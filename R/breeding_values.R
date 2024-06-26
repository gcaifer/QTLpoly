#' Prediction of QTL-based breeding values from REMIM model
#'
#' Computes breeding values for each genotyped individual based on multiple QTL models
#'
#' @param data an object of class \code{qtlpoly.data}.
#'
#' @param fitted an object of class \code{qtlpoly.fitted}.
#'
#' @param x an object of class \code{qtlpoly.bvalues} to be plotted.
#'
#' @param pheno.col a numeric vector with the phenotype column numbers to be plotted; if \code{NULL}, all phenotypes from \code{'data'} will be included.
#' 
#' @param ... currently ignored
#'
#' @return An object of class \code{qtlpoly.bvalues} which is a list of \code{results} for each trait containing the following components:
#'
#'     \item{pheno.col}{a phenotype column number.}
#'     \item{y.hat}{a column matrix of breeding value for each individual.}
#'
#' @return A \pkg{ggplot2} histogram with the distribution of breeding values.
#'
#' @seealso \code{\link[qtlpoly]{read_data}}, \code{\link[qtlpoly]{fit_model}}
#'
#' @examples
#'   \donttest{
#'   # Estimate conditional probabilities using mappoly package
#'   library(mappoly)
#'   library(qtlpoly)
#'   genoprob4x = lapply(maps4x[c(5)], calc_genoprob) #5,7
#'   data = read_data(ploidy = 4, geno.prob = genoprob4x, pheno = pheno4x, step = 1)
#'
#'   # Search for QTL
#'   remim.mod = remim(data = data, pheno.col = 1, w.size = 15, sig.fwd = 0.0011493379,
#' sig.bwd = 0.0002284465, d.sint = 1.5, n.clusters = 1)
#' 
#'   # Fit model
#'   fitted.mod = fit_model(data = data, model = remim.mod, probs = "joint", polygenes = "none")
#'
#'   # Predict genotypic values
#'   y.hat = breeding_values(data = data, fitted = fitted.mod)
#'   plot(y.hat)
#'   }
#'   
#' @author Guilherme da Silva Pereira, \email{gdasilv@@ncsu.edu}
#'
#' @references
#'     Pereira GS, Gemenet DC, Mollinari M, Olukolu BA, Wood JC, Mosquera V, Gruneberg WJ, Khan A, Buell CR, Yencho GC, Zeng ZB (2020) Multiple QTL mapping in autopolyploids: a random-effect model approach with application in a hexaploid sweetpotato full-sib population, \emph{Genetics} 215 (3): 579-595. \doi{10.1534/genetics.120.303080}.
#'
#' @export breeding_values

breeding_values <- function(data, fitted) {

  results <- vector("list", length(fitted$results))
  names(results) <- names(fitted$results)

  for(p in 1:length(fitted$results)) {

    if(!is.null(fitted$results[[p]]$qtls)) {

      nqtl <- dim(fitted$results[[p]]$qtls)[1]
      if(nqtl > 1) nqtl <- nqtl - 1
      markers <- unlist(fitted$results[[p]]$qtls[1:nqtl,"Nmrk"])
      u.hat <- fitted$results[[p]]$fitted$U
      beta.hat <- fitted$results[[p]]$fitted$Beta
      Z <- data$Z[,markers,]

      Zu <- vector("list", nqtl)
      if(nqtl > 1) {
        for(m in 1:nqtl) {
          Zu[[m]] <- t(Z[,m,]) %*% u.hat[[m]]
        }
        nind <- dim(Z)[3]
        y.hat <- matrix(rep(beta.hat, nind), byrow = FALSE) + Reduce("+", Zu)
      } else if(nqtl == 1) {
        Zu <- t(Z) %*% u.hat[[1]]
        nind <- dim(Z)[2]
        y.hat <- matrix(rep(beta.hat, nind), byrow = FALSE) + Zu
      }
    } else {
      y.hat <- NULL
    }
    if(!is.null(y.hat)) colnames(y.hat) = "T1"

    results[[p]] <- list(
      pheno.col=fitted$results[[p]]$pheno.col,
      y.hat = y.hat)
  }

  structure(list(data=deparse(substitute(data)),
                 fitted=deparse(substitute(fitted)),
                 pheno.col=fitted$pheno.col,
                 results=results),
            class="qtlpoly.bvalues")

}

#' @rdname breeding_values
#' @import ggplot2
#' @export

plot.qtlpoly.bvalues <- function(x, pheno.col = NULL, ...) {
  T1 = NULL
  if(is.null(pheno.col)) {
    pheno.col <- 1:length(x$results)
  } else {
    pheno.col <- which(x$pheno.col %in% pheno.col)
  }
  for(p in pheno.col) {
    if(!is.null(x$results[[p]]$y.hat)) {
      data <- data.frame(x$results[[p]]$y.hat)
      plot <- ggplot(data, aes(T1)) +
        geom_histogram(bins = 15) +
        labs(title=names(x$results)[p], y="Count", x="Predicted values") +
        theme_minimal() +
        theme(plot.title = element_text(hjust = 0.5), title=element_text(face="bold"))
      print(plot)
    }
  }
}
