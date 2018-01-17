#' @import methods

#' @title cuBLAS Matrix Multiplication
#' @description Multiply two gpuRcude objects, if they are conformable.
#' @param x A gpuRcuda object
#' @param y A gpuRcuda object
#' @docType methods
#' @rdname grapes-times-grapes-methods
#' @author Charles Determan Jr.
#' @importClassesFrom gpuRcuda cudaMatrix
#' @export
setMethod("%*%", signature(x="cudaMatrix", y = "cudaMatrix"),
          function(x,y)
          {
            if( dim(x)[2] != dim(y)[1]){
              stop("Non-conformant matrices")
            }
            return(cublas_gemm(x, y))
          },
          valueClass = "cudaMatrix"
)
