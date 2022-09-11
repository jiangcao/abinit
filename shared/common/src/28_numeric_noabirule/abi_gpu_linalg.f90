!{\src2tex{textfont=tt}}
!!****m* ABINIT/m_abi_gpu_linalg
!! NAME
!!  m_abi_gpu_linalg
!!
!! FUNCTION
!!  Interfaces of GPU subroutines wrapper
!!
!! COPYRIGHT
!!  Copyright (C) 2011-2022 ABINIT group (FDahm ))
!!  This file is distributed under the terms of the
!!  GNU General Public License, see ~ABINIT/Infos/copyright
!!  or http://www.gnu.org/copyleft/gpl.txt .
!!
!! SOURCE

!!***


!!****f* m_abi_gpu_linalg/alloc_on_gpu
!! NAME
!!  alloc_on_gpu
!!
!! FUNCTION
!!  Allocate size byte in gpu memory and returns in gpu_ptr this location
!!
!! INPUTS
!!  size= size in byte to allocate
!!
!! OUTPUT
!!  gpu_ptr= C_PTR on gpu memory location that has been allocated
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/dev_spec.cu
!!
!! SOURCE

#ifndef HAVE_GPU_CUDA

subroutine alloc_on_gpu(gpu_ptr,size)

!Arguments ------------------------------------
 type(c_ptr)             :: gpu_ptr
 integer    , intent(in) :: size ! size in bytes to allocate

 ABI_UNUSED(gpu_ptr)
 ABI_UNUSED(size)

end subroutine alloc_on_gpu
!!***

!!****f* m_abi_gpu_linalg/copy_from_gpu
!! NAME
!!  copy_from_gpu
!!
!! FUNCTION
!!  copy size byte from gpu memory (pointed by gpu_ptr) to cpu memory (pointed by cpu_ptr)
!!
!! INPUTS
!!  size_in_bytes = size in bytes to allocate
!!  gpu_ptr = C_PTR on gpu memory location that has been allocated
!!
!! OUTPUT
!!  cpu_ptr = C_PTR on cpu memory (obtained by c_loc)
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/dev_spec.cu
!!
!! SOURCE

subroutine copy_from_gpu(cpu_ptr,gpu_ptr,size_in_bytes)

!Arguments ------------------------------------
 type(c_ptr)                         :: cpu_ptr
 type(c_ptr)                         :: gpu_ptr
 integer(kind=c_int32_t), intent(in) :: size_in_bytes ! size in byte (to be transfered)

 ABI_UNUSED(cpu_ptr)
 ABI_UNUSED(gpu_ptr)
 ABI_UNUSED(size_in_bytes)

end subroutine copy_from_gpu
!!***

!!****f* m_abi_gpu_linalg/copy_on_gpu
!! NAME
!!  copy_on_gpu
!!
!! FUNCTION
!!  copy size byte from cpu (pointed by cpu_ptr) to gpu memory (pointed by gpu_ptr)
!!
!! INPUTS
!!  size_in_bytes = size in bytes to allocate
!!  cpu_ptr = C_PTR on cpu memory (obtained by c_loc)
!!
!! OUTPUT
!!  gpu_ptr= C_PTR on gpu memory location
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/dev_spec.cu
!!
!! SOURCE

subroutine copy_on_gpu(cpu_ptr,gpu_ptr,size_in_bytes)

  !Arguments ------------------------------------
  type(c_ptr)                         :: cpu_ptr
  type(c_ptr)                         :: gpu_ptr
  integer(kind=c_int32_t), intent(in) :: size_in_bytes ! size in byte (to be transfered)

  ABI_UNUSED(cpu_ptr)
  ABI_UNUSED(gpu_ptr)
  ABI_UNUSED(size_in_bytes)

end subroutine copy_on_gpu
!!***

!!****f* m_abi_gpu_linalg/copy_gpu_to_gpu
!! NAME
!!  copy_gpu_to_gpu
!!
!! FUNCTION
!!  copy size byte from gpu (src) to gpu (dest)
!!
!! INPUTS
!!  size_in_bytes = size in bytes to copy
!!  src_gpu_ptr = C_PTR on gpu memory
!!
!! OUTPUT
!!  dest_gpu_ptr = C_PTR on gpu memory
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/dev_spec.cu
!!
!! PARENTS
!!      lobpcgwf,m_abi_gpu_linalg
!!
!! SOURCE

subroutine copy_gpu_to_gpu(cpu_ptr,gpu_ptr,size_in_bytes)

  !Arguments ------------------------------------
  type(c_ptr)                         :: dest_cpu_ptr
  type(c_ptr)                         :: src_gpu_ptr
  integer(kind=c_int32_t), intent(in) :: size_in_bytes ! size in byte (to be transfered)

  ABI_UNUSED(dest_gpu_ptr)
  ABI_UNUSED(src_gpu_ptr)
  ABI_UNUSED(size_in_bytes)

end subroutine copy_gpu_to_gpu
!!***

!!****f* m_abi_gpu_linalg/dealloc_on_gpu
!! NAME
!!  dealloc_on_gpu
!!
!! FUNCTION
!!  free memory location pointed by gpu_ptr
!!
!! INPUTS
!!
!! OUTPUT
!!  gpu_ptr= C_PTR on gpu memory location that has been allocated
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/dev_spec.cu
!!
!! SOURCE

subroutine dealloc_on_gpu(gpu_ptr)

  !Arguments ------------------------------------
  type(c_ptr) :: gpu_ptr

  ABI_UNUSED(gpu_ptr)

end subroutine dealloc_on_gpu
!!***

!!****f* m_abi_gpu_linalg/gpu_memset
!! NAME
!!  gpu_memset
!!
!! FUNCTION
!!  Initializes or sets device memory to a value.
!!
!! INPUTS
!!  gpu_ptr= C_PTR on gpu memory location
!!  val= value used to initialized each bytes
!!  size= number of bytes to initialize
!!
!! OUTPUT
!!  gpu_ptr= C_PTR on gpu memory location
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/dev_spec.cu
!!
!! PARENTS
!!      lobpcgwf
!!
!! SOURCE

subroutine gpu_memset(gpu_ptr, val, array_size)

  !Arguments ------------------------------------
  type(c_ptr)                         :: gpu_ptr
  integer(kind=c_int32_t), intent(in) :: val
  integer(kind=c_int32_t), intent(in) :: array_size

  ABI_UNUSED(gpu_ptr)
  ABI_UNUSED(val)
  ABI_UNUSED(array_size)

end subroutine gpu_memset
!!***

!!****f* m_abi_gpu_linalg/gpu_allocated_impl
!! NAME
!!  gpu_allocated_impl
!!
!! FUNCTION
!!  Check if pointer points to allocated gpu device memory.
!!
!! INPUTS
!!  gpu_ptr= C_PTR on gpu memory location
!!
!! OUTPUT
!!  is_allocate= logical(c_bool) : true (if allocated), false (if not allocated)
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/dev_spec.cu
!!
!! PARENTS
!!      lobpcgwf
!!
!! SOURCE

subroutine gpu_allocated_impl(gpu_ptr, is_allocated)

  !Arguments ------------------------------------
  type(c_ptr)                       :: gpu_ptr
  logical(kind=c_bool), intent(out) :: is_allocated = .false.

  ABI_UNUSED(gpu_ptr)

end subroutine gpu_allocated_impl
!!***

!!****f* m_abi_gpu_linalg/gpu_linalg_init
!! NAME
!!  gpu_linalg_init
!!
!! FUNCTION
!!  initialisation of linalg environnement on GPU
!!
!! INPUTS
!!
!! OUTPUT
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/gpu_linalg.cu
!!
!! SOURCE

subroutine gpu_linalg_init()


end subroutine gpu_linalg_init
!!***

!!****f* m_abi_gpu_linalg/gpu_linalg_shutdown
!! NAME
!!  gpu_linalg_shutdown
!!
!! FUNCTION
!!  close linalg environnement on GPU
!!
!! INPUTS
!!
!! OUTPUT
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/gpu_linalg.cu
!!
!! SOURCE
subroutine gpu_linalg_shutdown()

end subroutine gpu_linalg_shutdown
!!***

!!****f* m_abi_gpu_linalg/gpu_xgemm
!! NAME
!!  gpu_xgemm
!!
!! FUNCTION
!!  Compute a scalar-matrix-matrix product and return a scalar-matrix product on GPU
!!  c = alpha * op(a) * op(b) + beta * c
!!
!! INPUTS
!!  cplx  = 1 if real 2 if complex
!!  transa= from of op(a) to be used in the matrix multiplication
!!  transb= from of op(b) to be used in the matrix multiplication
!!  m     = number of rows of the matrix op(a) and of the matrix c
!!  n     = number of rows of the matrix op(b) and the number of columns of the matrix c
!!  k     = number of columns of the matrix op(a) and the number of rows of the matrix op(b)
!!  alpha = alpha scalar coefficient for matrix op(a)
!!  a_gpu = pointer to gpu memory location of  matrix a
!!  lda   = first dimension of a
!!  b_gpu = pointer to gpu memory location of  matrix b
!!  ldb   = first dimension of b
!!  beta  = beta scalar coefficient for matrix c
!!  c_gpu = pointer to gpu memory location of  matrix c
!!  ldc   = first dimension of c
!!
!! OUTPUT
!!  c     = c matrix
!!
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/gpu_linalg.cu
!!
!! SOURCE

subroutine gpu_xgemm(cplx,transa,transb,m,n,k,alpha,a_gpu,lda,b_gpu,ldb,beta,c_gpu,ldc)

!Arguments ------------------------------------
 integer,intent(in) :: cplx,lda,ldb,ldc,m,n,k
 complex(dpc),intent(in) :: alpha,beta
 character(len=1),intent(in) :: transa,transb
 type(c_ptr),intent(in) :: a_gpu,b_gpu
 type(c_ptr),intent(inout) :: c_gpu
!Local variables ------------------------------
 type(c_ptr) :: cptr

! *********************************************************************

 if (.false.) then
   cptr=a_gpu;cptr=b_gpu;cptr=c_gpu
   write(std_out,*) transa,transb,cplx,lda,ldb,ldc,m,n,k,alpha,beta
 end if

end subroutine gpu_xgemm
!!***

!!****f* m_abi_gpu_linalg/gpu_xtrsm
!! NAME
!!  gpu_xtrsm
!!
!! FUNCTION
!! Solves a matrix equation (one matrix operand is triangular) on GPU.
!! The xtrsm routines solve one of the following matrix equations
!! op(a)*x = alpha*b
!! or
!! x*op(a) = alpha*b,
!!
!! INPUTS
!! cplx= 1 if real 2 if complex
!! side= Specifies whether op(a) appears on the left or right of x for
!!      the operation to be performed as follows:
!!      L or l op(a)*x = alpha*b
!!      R or r x*op(a) = alpha*b
!! uplo= Specifies whether the matrix a is an upper or lower triangular
!!      matrix as follows:
!!      U or u Matrix a is an upper triangular matrix.
!!      L or l Matrix a is a lower triangular matrix
!! transa= Specifies the form of op(a) to be used in the matrix
!!      multiplication as follows:
!!      N or n op(a) = a
!!      T or t op(a) = a'
!!      C or c op(a) = conjg(a')
!! diag= Specifies whether or not a is unit triangular as follows:
!!      U or u Matrix a is assumed to be unit triangular.
!!      N or n Matrix a is not assumed to be unit triangular.
!! m= Specifies the number of rows of b. The value of m must be at least zero
!! n= Specifies the number of columns of b. The value of n must be at least zero
!! alpha= Specifies the scalar alpha. When alpha is zero, then a is not referenced and b
!!      need not be set before entry.
!!  a_gpu = pointer to gpu memory location of  array a, DIMENSION (lda, k), where k is m when side = 'L' or 'l' and is n
!!      when side = 'R' or 'r'.
!! lda= Specifies the first dimension of a as declared in the calling
!!     (sub)program. When side = 'L' or 'l', then lda must be at least max(1,
!!      m), when side = 'R' or 'r', then lda must be at least max(1, n).
!!  b_gpu = pointer to gpu memory location of  b Array, DIMENSION (ldb,n). Before entry, the leading m-by-n part of the array
!!     b must contain the right-hand side matrix b.
!! ldb= Specifies the first dimension of b as declared in the calling
!!     (sub)program. The value of ldb must be at least max(1, m).
!!
!! OUTPUT
!!  b_gpu
!!
!! SIDE EFFECTS
!!   WARNING! : this routine is a dummy one when HAVE_GPU_CUDA is not enabled
!!   the correct one is in 17_gpu_toolbox/gpu_linalg.cu
!!
!! SOURCE
subroutine gpu_xtrsm(cplx,side,uplo,transa,diag,m,n,alpha,a_gpu,lda,b_gpu,ldb)

! !Arguments ------------------------------------
 integer, intent(in) :: cplx,lda,ldb,m,n
 complex(dpc), intent(in) :: alpha
 character(len=1), intent(in) :: side,uplo,transa,diag
 type(c_ptr),intent(in) :: a_gpu
 type(c_ptr),intent(inout) :: b_gpu
!Local variables ------------------------------
 type(c_ptr) :: cptr

! *********************************************************************

 if (.false.) then
   cptr=a_gpu;cptr=b_gpu
   write(std_out,*) side,uplo,transa,diag,cplx,lda,ldb,m,n,alpha
 end if

end subroutine gpu_xtrsm
!!***

!!****f* m_abi_gpu_linalg/gpu_xaxpy
!! NAME
!!  gpu_xaxpy
!!
!! FUNCTION
!!  Compute a BLAS-1 AXPY operation on GPU
!!  y = alpha * x + y
!!
!! INPUTS
!!  cplx  = 1 if real 2 if complex
!!  size  = vector size
!!  alpha = scalar complex value
!!  x_gpu = pointer to gpu memory location of array x
!! incrx  = stride between consecutive elements of x
!!  y_gpu = pointer to gpu memory location of array y
!! incry  = stride between consecutive elements of y
!!
!! SOURCE
subroutine gpu_xaxpy(cplx, size, alpha, x_gpu, incrx, y_gpu, incry)

  ! !Arguments ------------------------------------
  integer,      intent(in)    :: cplx
  integer,      intent(in)    :: size
  complex(dpc), intent(in)    :: alpha
  type(c_ptr),  intent(in)    :: x_gpu
  integer,      intent(in)    :: incrx
  type(c_ptr),  intent(inout) :: y_gpu
  integer,      intent(in)    :: incry

end subroutine gpu_xaxpy
!!***

!!****f* m_abi_gpu_linalg/gpu_xscal
!! NAME
!!  gpu_xscal
!!
!! FUNCTION
!!  Compute a BLAS-1 SCAL operation on GPU
!!  x = alpha * x
!!
!! INPUTS
!!  cplx  = 1 if real 2 if complex
!!  size  = vector size
!!  alpha = scalar complex value
!!  x_gpu = pointer to gpu memory location of array x
!! incrx  = stride between consecutive elements of x
!!
!! SOURCE
subroutine gpu_xscal(cplx, size, alpha, x_gpu, incrx)

  ! !Arguments ------------------------------------
  integer,      intent(in)    :: cplx
  integer,      intent(in)    :: size
  complex(dpc), intent(in)    :: alpha
  type(c_ptr),  intent(in)    :: x_gpu
  integer,      intent(in)    :: incrx

end subroutine gpu_xscal
!!***

#endif


!!****f* m_abi_linalg/gpu_xorthonormalize
!! NAME
!!  gpu_xorthonormalize
!!
!! FUNCTION
!!  This routine computes the overlap of two complex wavefunctions (for a given number of bands)
!!  and orthonormalizes it using gpu:
!!      - Computes the products of two rectangular matrices
!!         containing the wavefunctions psi and S.psi (where S is the
!!         overlap (with the PAW terms if necessary)).
!!      - Does a Cholesky decomposition of this overlap
!!      - rotates the initial matrix blockvectorx by the triangular matrix to
!!         have an orthonormal set of wavefunctions
!!
!! INPUTS
!!  blockvectorbx = matrix of dimension (blocksize,vectsize) as a GPU ptr
!!                  (e.g. block of overlap*wavefunction)
!!  blocksize     = dimension of matrices (e.g number of bands)
!!  spaceComm     = communicator used for  MPI parallelization
!!  vectsize      = dimension of matrices (e.g number of G vector)
!!
!! OUTPUT
!!  sqgram        = Choleski decomposition of transpose(blockvector)*blockvectorx as a GPU ptr
!!
!! SIDE EFFECTS
!!  blockvectorx  = on input, matrix of dimension (vectsize,blocksize) as a GPU ptr
!!                  (e.g block of wavefunction)
!!  blockvectorx  = on output, orthonormalized wavefunction. as a GPU ptr
!!
!!
!! SOURCE

subroutine gpu_xorthonormalize(blockvectorx_gpu,blockvectorbx_gpu,blocksize,spaceComm,&
&                              sqgram_gpu,vectsize,&
&                              x_cplx,timopt,tim_xortho) ! optional arguments

  use, intrinsic :: iso_c_binding
  implicit none

!Arguments ------------------------------------
!scalars
 integer,intent(in) :: blocksize,spaceComm,vectsize,x_cplx
 integer, intent(in), optional :: timopt,tim_xortho
!arrays
 type(c_ptr),intent(inout) :: blockvectorbx_gpu, blockvectorx_gpu,sqgram_gpu
!Local variables-------------------------------
#if defined HAVE_GPU_CUDA
 integer :: ierr,info
 real(dp),dimension(:,:),allocatable, target :: d_sqgram
 complex(dpc),dimension(:,:),allocatable, target :: z_sqgram
 character :: tr
 real(dp) :: tsec(2)
#else
 type(c_ptr) :: cptr_a
#endif
 character(len=500) :: message

! *********************************************************************
#if defined HAVE_GPU_CUDA
 if (present(tim_xortho).and.present(timopt)) then
   if(abs(timopt)==3) then
     call timab(tim_xortho,1,tsec)
   end if
 end if

 if ( x_cplx == 1 ) then
   tr='t'
   ABI_MALLOC(d_sqgram,(blocksize,blocksize))
 else
   tr='c'
   ABI_MALLOC(z_sqgram,(blocksize,blocksize))
 end if

 call gpu_xgemm(x_cplx,tr,'n',blocksize,blocksize,vectsize, &
& cone,blockvectorx_gpu,vectsize,blockvectorbx_gpu,vectsize,czero,sqgram_gpu,blocksize)

 if ( x_cplx == 1 ) then
   call copy_from_gpu(C_LOC(d_sqgram(1,1)),sqgram_gpu,x_cplx*dp*blocksize*blocksize)
   call xmpi_sum(d_sqgram,spaceComm,ierr)
   call abi_xpotrf('u',blocksize,d_sqgram,blocksize,info)
   call copy_on_gpu(C_LOC(d_sqgram(1,1)),sqgram_gpu,x_cplx*dp*blocksize*blocksize)
 else
   call copy_from_gpu(C_LOC(z_sqgram(1,1)),sqgram_gpu,x_cplx*dp*blocksize*blocksize)
   call xmpi_sum(z_sqgram,spaceComm,ierr)
   call abi_xpotrf('u',blocksize,z_sqgram,blocksize,info)
   call copy_on_gpu(C_LOC(z_sqgram(1,1)),sqgram_gpu,x_cplx*dp*blocksize*blocksize)
 end if

 if (info /= 0 ) then
   write(message,'(a,i3)') '  xpotrf, info=',info
   ABI_WARNING(message)
 end if

 call gpu_xtrsm(x_cplx,'r','u','n','n',vectsize,blocksize,cone,sqgram_gpu,blocksize,&
&               blockvectorx_gpu,vectsize)

 if(x_cplx==1) then
   ABI_FREE(d_sqgram)
 else
   ABI_FREE(z_sqgram)
 end if
 if (present(tim_xortho).and.present(timopt)) then
   if(abs(timopt)==3) then
     call timab(tim_xortho,2,tsec)
   end if
 end if
 return

#else
 message='  This routine is not allowed when Cuda is disabled !'
 ABI_BUG(message)
 if (.false.) then
   write(std_out,*) blocksize,vectsize,spaceComm,x_cplx
   if (present(timopt))  write(std_out,*) timopt
   if (present(tim_xortho))  write(std_out,*) tim_xortho
   cptr_a=blockvectorbx_gpu;cptr_a=blockvectorx_gpu;cptr_a=sqgram_gpu
 end if
#endif

end subroutine gpu_xorthonormalize
!!***
