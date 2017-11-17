#' Bootstrap glinternet models
#'
#' Create a list of bootstrapped glinternet models from synthetic data,
#' and save it as "output.RData" in the current directory.
#'
#' @param B         Number of Bootstrap samples
#' @param minLambda Smallest lambda value
#' @param maxLambda Largest lambda value
#' @param nLambda   How many lambda values
#' @export

bootglinternet <- function(B=5, maxLambda=exp(-6.5), minLambda=exp(-8.5),
                           nLambda=20){
    data("synthetic")
    z <- synthetic[ ,!names(synthetic) %in% c('age', 'gold_standard')] # categorical variables
    z$timeonantidepcat <- z[ , "timeonantidepcat"] - 1
    #categoricals need to start at 0
    x <- synthetic$age
    y <- synthetic$gold_standard

    numLevels <-
        c(1,apply(X = z, MARGIN = 2, FUN = function(x){length(unique(x))}))
    # Prepend 1 for continuous variable 'age', coded with 1 as number of
    # levels.
    n <- dim(z)[1] # number of rows
    lambda <- exp(seq(from = log(maxLambda), to = log(minLambda),
                  length.out = nLambda))
    full_fit <- glinternet::glinternet(X = cbind(x,z), Y = y,
             numLevels = numLevels,
              lambda = lambda, family = "binomial", verbose = TRUE)
    cl <- parallel::makeCluster(parallel::detectCores())
    doParallel::registerDoParallel(cl)
    library(foreach)
    tryCatch(expr = {
      output <- foreach::foreach(b = 1:B, .packages = "glinternet") %dopar% {
      bootI <- sample(x = 1:n, size = n, replace = TRUE)
      fit <- glinternet::glinternet(X = cbind(x,z)[bootI,], Y = y[bootI],
                 numLevels = numLevels,
                  lambda = lambda, family = "binomial", verbose = TRUE)
      oobI <- (1:n)[!1:n %in% bootI]
      yhat <-predict(object=fit, X = cbind(x[oobI], z[oobI,]), type = "link")
      return(list(model=fit, bootI=bootI, yhat=yhat, oobI=oobI))
    }
    }, finally = {
        save(full_fit, output, y, file = "data/glinternet_models.RData")
        parallel::stopCluster(cl)
      })
}



