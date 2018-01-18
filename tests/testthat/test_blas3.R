library(gpuRcublas)
context("cudaMatrix algebra")

# set seed
set.seed(123)

ORDER <- 4

# Base R objects
A <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
B <- matrix(rnorm(ORDER^2), nrow=ORDER, ncol=ORDER)
E <- matrix(rnorm(15), nrow=5)

# Single Precision tests

test_that("cudaMatrix Single Precision Matrix multiplication", {
  
  skip_on_travis()
  
  C <- A %*% B
  
  fgpuA <- cudaMatrix(A, type="float")
  fgpuB <- cudaMatrix(B, type="float")
  fgpuE <- cudaMatrix(E, type = "float")
  
  fgpuC <- fgpuA %*% fgpuB
  
  expect_is(fgpuC, "fcudaMatrix")
  expect_equal(fgpuC[,], C, tolerance=1e-07, 
               info="float matrix elements not equivalent")  
  expect_error(fgpuA %*% fgpuE,
               info = "error not thrown for non-conformant matrices")
  
  ### tests to be run when methods for cudaMatrix/base::matrix are implemented 
  
  # fgpuC <- A %*% fgpuB
  # 
  # expect_is(fgpuC, "fgpuMatrix")
  # expect_equal(fgpuC[,], C, tolerance=1e-07, 
  #              info="float matrix elements not equivalent")  
  # 
  # fgpuC <- fgpuA %*% B
  # 
  # expect_is(fgpuC, "fgpuMatrix")
  # expect_equal(fgpuC[,], C, tolerance=1e-07, 
  #              info="float matrix elements not equivalent")  
})