

#include <cublas_v2.h>

#include <gpuRcuda/device_matrix.hpp>

#include <string>
#include <unordered_map>

// typedef enum {
//   cublasSgemm,
//   cublasDgemm
// } cublasgemm;
  
    
  
/* const std::unordered_map<std::string, cublasStatus_t> gemm_methods {
  {"float", cublasSgemm},
  {"double", cublasDgemm}
}; */

// void gpu_blas_mmul(cublasHandle_t &handle, const float *A, const float *B, float *C, const int m, const int k, const int n) {
//   2     int lda=m,ldb=k,ldc=m;
//   3     const float alf = 1;
//   4     const float bet = 0;
//   5     const float *alpha = &alf;
//   6     const float *beta = &bet;
//   7 
//   8     // Do the actual multiplication
//   9     cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, alpha, A, lda, B, ldb, beta, C, ldc);
//   10 }

template <typename T>
void cublas_gemm(
  cublasHandle_t &handle,
  cublasOperation_t transA, cublasOperation_t transB,
  int m, int n, int k,
  T alpha,
  const T* A, int lda,
  const T* B, int ldb,
  T beta,
  T* C, int ldc) {
      throw Rcpp::exception("default gemm method called in error");
}

template <>
void cublas_gemm(
  cublasHandle_t &handle,
  cublasOperation_t transA, cublasOperation_t transB,
  int m, int n, int k,
  float alpha,
  const float* A, int lda,
  const float* B, int ldb,
  float beta,
  float* C, int ldc) {
  
    std::cout << "entered float function" << std::endl;
  
      cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, &alpha, A, lda, B, ldb, &beta, C, ldc);
}

template <>
void cublas_gemm(
  cublasHandle_t &handle,
  cublasOperation_t transA, cublasOperation_t transB,
  int m, int n, int k,
  double alpha,
  const double* A, int lda,
  const double* B, int ldb,
  double beta,
  double* C, int ldc) {
      cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, &alpha, A, lda, B, ldb, &beta, C, ldc);
}

template <typename T>
void cublasGemm(SEXP A, SEXP B, SEXP C, std::string type){
  Rcpp::XPtr<device_matrix<T> > pA(A);
  Rcpp::XPtr<device_matrix<T> > pB(B);
  Rcpp::XPtr<device_matrix<T> > pC(C);
  
  cublasStatus_t stat; // CUBLAS Status
  cublasHandle_t handle; // CUBLAS context
  
  stat = cublasCreate(&handle); 
  if (stat != CUBLAS_STATUS_SUCCESS) { 
    throw Rcpp::exception("cuBLAS initialization failed!");
  }
  
  //auto gemm_iter = gemm_methods.find(type);
  
  //cublasStatus_t gemm = gemm_iter->second();
  
  int m = pA->nrow(), k = pA->ncol(), n = pB->nrow();
  
  const T alpha = 1;
  const T beta = 0;
  // const T *alpha = &alf;
  // const T *beta = &bet;
  
  int lda=m,ldb=k,ldc=m;
  
  std::cout << "about to call templated cublas" << std::endl;
  
  // cublasSgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, alpha, A, lda, B, ldb, beta, C, ldc);
  cublas_gemm(handle, 
       CUBLAS_OP_N,
       CUBLAS_OP_N,
       m,
       n,
       k,
       alpha,
       thrust::raw_pointer_cast(pA->getPtr()->data()), 
       lda,
       thrust::raw_pointer_cast(pB->getPtr()->data()), 
       ldb,
       beta,
       thrust::raw_pointer_cast(pC->getPtr()->data()), 
       ldc);
  
  return;
}

// [[Rcpp::export]]
void 
cublasGemm(SEXP A, SEXP B, SEXP C, std::string type, const int type_flag)
{
  std::cout << "entered c++" << std::endl;
  switch(type_flag){
  case 6:
      cublasGemm<float>(A, B, C, type);
      return;
  case 8:
      cublasGemm<double>(A, B, C, type);
      return;
  default:
      throw Rcpp::exception("unknown type detected for gpuRcublas object!");
  }
}



