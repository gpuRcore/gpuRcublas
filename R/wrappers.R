
#' @importFrom gpuRcuda cudaMatrix
cublas_gemm <- function(A, B){
  
  type = typeof(A)
  
  print('got type')
  
  C <- cudaMatrix(nrow = nrow(A), ncol = ncol(B), type = type)
  
  print('output initialized')
  
  switch(type,
         float = {cpp_gpuMatrix_gemm(A@address,
                                     B@address,
                                     C@address,
                                     6L)
         },
         double = {
           cpp_gpuMatrix_gemm(A@address,
                              B@address,
                              C@address,
                              8L)
         },
         stop("type not implemented")
  )
  
  return(C)
  
}

