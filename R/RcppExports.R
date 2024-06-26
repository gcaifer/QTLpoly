# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

seqCpp <- function(a, b) {
    .Call(`_qtlpoly_seqCpp`, a, b)
}

mat_to_vecCpp <- function(x, x2) {
    .Call(`_qtlpoly_mat_to_vecCpp`, x, x2)
}

vec_to_cubeCpp <- function(x, g) {
    .Call(`_qtlpoly_vec_to_cubeCpp`, x, g)
}

varCols <- function(x) {
    .Call(`_qtlpoly_varCols`, x)
}

scaleCpp <- function(x) {
    .Call(`_qtlpoly_scaleCpp`, x)
}

isIdentity_mat <- function(x) {
    .Call(`_qtlpoly_isIdentity_mat`, x)
}

isIdentity_spmat <- function(x) {
    .Call(`_qtlpoly_isIdentity_spmat`, x)
}

isDiagonal_mat <- function(x) {
    .Call(`_qtlpoly_isDiagonal_mat`, x)
}

isDiagonal_spmat <- function(x) {
    .Call(`_qtlpoly_isDiagonal_spmat`, x)
}

MNR <- function(Y, X, Gx, Z, K, R, Ge, GeI, ws, iters, tolpar, tolparinv, ai, pev, verbose, retscaled, stepweight, emupdate) {
    .Call(`_qtlpoly_MNR`, Y, X, Gx, Z, K, R, Ge, GeI, ws, iters, tolpar, tolparinv, ai, pev, verbose, retscaled, stepweight, emupdate)
}

