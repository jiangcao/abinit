#if defined HAVE_CONFIG_H
#include "config.h"
#endif

#include "abi_common.h"

module m_tdep_shell

  use defs_basis
  use m_errors
  use m_profiling_abi
  use m_tdep_readwrite,   only : Input_Variables_type
  use m_tdep_latt,        only : Lattice_Variables_type
  use m_tdep_sym,         only : Symetries_Variables_type, tdep_SearchS_2at, tdep_SearchS_3at
  use m_tdep_utils,       only : tdep_calc_nbcoeff

  implicit none

  type List_of_neighbours
    integer :: n_interactions
    integer, allocatable :: atomj_in_shell(:)
    integer, allocatable :: atomk_in_shell(:)
    integer, allocatable :: sym_in_shell(:)
    integer, allocatable :: transpose_in_shell(:)
  end type List_of_neighbours  

  type Shell_Variables_type
    integer :: nshell
    integer, allocatable :: ncoeff(:)
    integer, allocatable :: ncoeff_prev(:)
    integer, allocatable :: iatref(:)
    integer, allocatable :: jatref(:)
    integer, allocatable :: katref(:)
    type(List_of_neighbours),allocatable :: neighbours(:,:)
  end type Shell_Variables_type

  public :: tdep_init_shell2at
  public :: tdep_init_shell3at
  public :: tdep_destroy_shell

contains 

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 subroutine tdep_init_shell2at(distance,InVar,norder,nshell_max,ntotcoeff,order,proj,Shell2at,Sym)


!This section has been created automatically by the script Abilint (TD).
!Do not modify the following lines by hand.
#undef ABI_FUNC
#define ABI_FUNC 'tdep_init_shell2at'
!End of the abilint section

  implicit none
  type(Input_Variables_type),intent(in) :: InVar
  type(Shell_Variables_type),intent(out) :: Shell2at
  type(Symetries_Variables_type),intent(inout) :: Sym
  integer,intent(in) :: norder,order,nshell_max
  integer,intent(out) :: ntotcoeff
  double precision, intent(in) :: distance(InVar%natom,InVar%natom,4)
  double precision, intent(out) :: proj(norder,norder,nshell_max)

  integer :: ishell,iatcell,iatom,jatom,eatom,fatom,iatref,jatref
  integer :: natom,natom_unitcell,counter,ncoeff,ncoeff_prev
  integer, allocatable :: ref2at(:,:,:),Isym2at(:,:,:)

  natom         =InVar%natom
  natom_unitcell=InVar%natom_unitcell

! - Identify the shells
! - Store the index of the atoms included in each shell
! - Store the reference atoms for each shell
! - Compute the symetry operation between the reference atom and another one
  write(InVar%stdout,*) ' Build the ref2at and Isym2at tables...'
  ABI_MALLOC(ref2at ,(natom,natom,3)) ; ref2at (:,:,:)=zero
  ABI_MALLOC(Isym2at,(natom,natom,2)) ; Isym2at(:,:,:)=zero
  ishell=0
  do iatcell=1,natom_unitcell
    do jatom=1,natom
!     Interactions are only computed until Rcut<acell/2 in order to have complete shell of neighbours.
!     Otherwise the symetries are broken.
      if ((ref2at(iatcell,jatom,1).ne.0).or.(distance(iatcell,jatom,1).gt.(InVar%Rcut*0.99))) cycle
      ishell=ishell+1
      do eatom=1,natom
        do fatom=1,natom
          if ((ref2at(eatom,fatom,1).eq.0).and.&
&         (abs(distance(iatcell,jatom,1)-distance(eatom,fatom,1)).lt.1.d-3)) then
            call tdep_SearchS_2at(InVar,iatcell,jatom,eatom,fatom,Isym2at,Sym,InVar%xred_ideal)
            if (Isym2at(eatom,fatom,2)==1) then
              if (InVar%debug) write(InVar%stdout,'(a,1x,4(i4,1x),a,i4)') &
&                'For:',iatcell,jatom,eatom,fatom,' direct transformation with isym=',Isym2at(eatom,fatom,1)
              ref2at(eatom,fatom,1)=iatcell
              ref2at(eatom,fatom,2)=jatom
              ref2at(eatom,fatom,3)=ishell
!             The Phij_NN has to be symetric (transposition symetries)              
              if (InVar%debug) write(InVar%stdout,'(a,1x,4(i4,1x),a,i4)') &
&                'For:',iatcell,jatom,eatom,fatom,' transformation+permutation with isym=',Isym2at(eatom,fatom,1)
              ref2at(fatom,eatom,1)=iatcell
              ref2at(fatom,eatom,2)=jatom
              ref2at(fatom,eatom,3)=ishell
              Isym2at(fatom,eatom,1)=Isym2at(eatom,fatom,1)
              Isym2at(fatom,eatom,2)=2
            else  
              if (InVar%debug) write(InVar%stdout,'(a,4(1x,i4))') &
&                'NO SYMETRY OPERATION BETWEEN (iatom,jatom) and (eatom,fatom)=',iatcell,jatom,eatom,fatom
            end if  
          end if !already treated
        end do !fatom
      end do !eatom
    end do !jatom 
  end do !iatcell 
  Shell2at%nshell=ishell
  if (Shell2at%nshell.gt.nshell_max) then
    write(InVar%stdout,*) '  STOP : The maximum number of shells allowed by the code is:',nshell_max
    write(InVar%stdout,*) '         In the present calculation, the number of shells is:',Shell2at%nshell
    write(InVar%stdout,*) '         Action: increase nshell_max'
    MSG_ERROR('The maximum number of shells allowed by the code is reached')
  end if  


! Store all the previous quantities in a better way than in ref2at (without using too memory).
  write(InVar%stdout,*) ' Build the Shell2at datatype...'
  ABI_MALLOC(Shell2at%neighbours,(natom,Shell2at%nshell))
  ABI_MALLOC(Shell2at%iatref          ,(Shell2at%nshell)); Shell2at%iatref(:)=zero
  ABI_MALLOC(Shell2at%jatref          ,(Shell2at%nshell)); Shell2at%jatref(:)=zero
  do ishell=1,Shell2at%nshell
    do iatom=1,natom
      counter=0
      do jatom=1,natom
        if (ref2at(iatom,jatom,3).eq.ishell) counter=counter+1 
      end do
      Shell2at%neighbours(iatom,ishell)%n_interactions=counter
      if (counter.eq.0) cycle
      ABI_MALLOC(Shell2at%neighbours(iatom,ishell)%atomj_in_shell,(counter))
      ABI_MALLOC(Shell2at%neighbours(iatom,ishell)%sym_in_shell,(counter))
      ABI_MALLOC(Shell2at%neighbours(iatom,ishell)%transpose_in_shell,(counter))
      Shell2at%neighbours(iatom,ishell)%atomj_in_shell(:)=zero
      Shell2at%neighbours(iatom,ishell)%sym_in_shell(:)=zero
      Shell2at%neighbours(iatom,ishell)%transpose_in_shell(:)=zero
      counter=0
      do jatom=1,natom
        if (ref2at(iatom,jatom,3).eq.ishell) then
          counter=counter+1
          Shell2at%neighbours(iatom,ishell)%atomj_in_shell(counter)=jatom
          Shell2at%iatref         (ishell)=ref2at(iatom,jatom,1)
          Shell2at%jatref         (ishell)=ref2at(iatom,jatom,2)
          Shell2at%neighbours(iatom,ishell)%sym_in_shell      (counter)=Isym2at(iatom,jatom,1)
          Shell2at%neighbours(iatom,ishell)%transpose_in_shell(counter)=Isym2at(iatom,jatom,2)
        end if  
      end do
    end do
  end do
  ABI_FREE(ref2at)
  ABI_FREE(Isym2at)

! Find the number of coefficients of the (3x3) Phij for a given shell
  ABI_MALLOC(Shell2at%ncoeff     ,(Shell2at%nshell)); Shell2at%ncoeff(:)=zero
  ABI_MALLOC(Shell2at%ncoeff_prev,(Shell2at%nshell)); Shell2at%ncoeff_prev(:)=zero
  write(InVar%stdout,*) ' Number of shells=',Shell2at%nshell
  write(InVar%stdout,*) '============================================================================'
  open(unit=16,file='nbcoeff-phij.dat')
  ncoeff_prev=0
  do ishell=1,Shell2at%nshell
    ncoeff=0
    iatref=Shell2at%iatref(ishell)
    jatref=Shell2at%jatref(ishell)
    write(InVar%stdout,*) 'Shell number:',ishell 
    write(InVar%stdout,'(a,i5,a,i5,a,f16.10)') '  Between atom',iatref,' and ',jatref,' the distance is=',distance(iatref,jatref,1)
    call tdep_calc_nbcoeff(distance,iatref,InVar,ishell,jatref,1,ncoeff,norder,Shell2at%nshell,order,proj,Sym)
    Shell2at%ncoeff     (ishell)=ncoeff
    Shell2at%ncoeff_prev(ishell)=ncoeff_prev
    ncoeff_prev=ncoeff_prev+ncoeff
    write(InVar%stdout,*)'  Number of independant coefficients in this shell=',ncoeff
    write(InVar%stdout,*) '============================================================================'
  end do  
  write(InVar%stdout,*)'  >>>>>> Total number of coefficients in these shells=',ncoeff_prev
  close(16)
  ntotcoeff=ncoeff_prev

 end subroutine

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 subroutine tdep_init_shell3at(distance,InVar,norder,nshell_max,ntotcoeff,order,proj,Shell3at,Sym)


!This section has been created automatically by the script Abilint (TD).
!Do not modify the following lines by hand.
#undef ABI_FUNC
#define ABI_FUNC 'tdep_init_shell3at'
!End of the abilint section

  implicit none
  type(Input_Variables_type),intent(in) :: InVar
  type(Shell_Variables_type),intent(out) :: Shell3at
  type(Symetries_Variables_type),intent(inout) :: Sym
  integer, intent(in) :: norder,order,nshell_max
  integer, intent(out) :: ntotcoeff
  double precision, intent(in) :: distance(InVar%natom,InVar%natom,4)
  double precision, intent(out) :: proj(norder,norder,nshell_max)

  integer :: ii,ishell,iatcell,iatom,jatom,katom,eatom,fatom,gatom,iatref,jatref,katref
  integer :: natom,natom_unitcell,watom,xatom,yatom,counter,ncoeff,ncoeff_prev
  double precision :: norm1,norm2
  integer, allocatable :: ref3at(:,:,:,:),Isym3at(:,:,:,:)

  natom         =InVar%natom
  natom_unitcell=InVar%natom_unitcell

! - Identify the shells
! - Store the index of the (couple of) atoms included in each shell
! - Store the reference (couple of) atoms for each shell
! - Compute the symetry operation between the reference (couple of) atoms and another one
  ABI_MALLOC(ref3at ,(natom,natom,natom,4)) ; ref3at(:,:,:,:)=zero
  ABI_MALLOC(Isym3at,(natom,natom,natom,2)) ; Isym3at(:,:,:,:)=zero
  ishell=0
  do iatcell=1,natom_unitcell
    do jatom=1,natom
      do katom=1,natom
!FB        if((iatcell.ne.jatom).and.(iatcell.ne.katom).and.(jatom.ne.katom)) cycle
!       WARNING: distance(j,k).ne.|djk| due to the inbox procedure when computing distance(j,k). 
!                So, compute |djk| using vec(ij) and vec(ik).      
        norm1=dsqrt((distance(iatcell,katom,2)-distance(iatcell,jatom,2))**2+&
&                   (distance(iatcell,katom,3)-distance(iatcell,jatom,3))**2+&
&                   (distance(iatcell,katom,4)-distance(iatcell,jatom,4))**2)
!       Interactions are only computed until Rcut3<acell/2 in order to have complete shell of neighbours.
!       Otherwise the symetries are broken.
        if ((ref3at(iatcell,jatom,katom,1).ne.0).or.&
&          (distance(iatcell,jatom,1).gt.(InVar%Rcut3*0.99)).or.&
&          (norm1                    .gt.(InVar%Rcut3*0.99)).or.&
&          (distance(iatcell,katom,1).gt.(InVar%Rcut3*0.99))) cycle
        ishell=ishell+1
        if (InVar%debug) write(InVar%stdout,'(a)') &
&          'NEW SHELL'
        do eatom=1,natom
          do fatom=1,natom
            do gatom=1,natom
!             WARNING: distance(f,g).ne.|dfg| due to the inbox procedure when computing distance(f,g). 
!                      So, compute |dfg| using vec(ef) and vec(eg).      
              norm2=dsqrt((distance(eatom,gatom,2)-distance(eatom,fatom,2))**2+&
&                         (distance(eatom,gatom,3)-distance(eatom,fatom,3))**2+&
&                         (distance(eatom,gatom,4)-distance(eatom,fatom,4))**2)
              if ((ref3at(eatom,fatom,gatom,1).eq.0).and.&
&                ((abs(distance(iatcell,jatom,1)-distance(eatom,fatom,1)).lt.1.d-3).and.&
&                 (abs(norm1                    -norm2                  ).lt.1.d-3).and.&
&                 (abs(distance(iatcell,katom,1)-distance(eatom,gatom,1)).lt.1.d-3))) then
                call tdep_SearchS_3at(InVar,iatcell,jatom,katom,eatom,fatom,gatom,Isym3at,Sym,InVar%xred_ideal)
                if (Isym3at(eatom,fatom,gatom,2)==1) then
                  do ii=1,6
!                   The Phij_NN has to be symetric (transposition symetries)
                    if (ii==1) then ; watom=eatom ; xatom=fatom ; yatom=gatom ; endif !\Psi_efg
                    if (ii==2) then ; watom=eatom ; xatom=gatom ; yatom=fatom ; endif !\Psi_egf
                    if (ii==3) then ; watom=fatom ; xatom=eatom ; yatom=gatom ; endif !\Psi_feg
                    if (ii==4) then ; watom=fatom ; xatom=gatom ; yatom=eatom ; endif !\Psi_fge
                    if (ii==5) then ; watom=gatom ; xatom=eatom ; yatom=fatom ; endif !\Psi_gef
                    if (ii==6) then ; watom=gatom ; xatom=fatom ; yatom=eatom ; endif !\Psi_gfe
                    ref3at(watom,xatom,yatom,1)=iatcell
                    ref3at(watom,xatom,yatom,2)=jatom
                    ref3at(watom,xatom,yatom,3)=katom
                    ref3at(watom,xatom,yatom,4)=ishell
                    Isym3at(watom,xatom,yatom,1)=Isym3at(eatom,fatom,gatom,1)
                    Isym3at(watom,xatom,yatom,2)=ii
                    if (InVar%debug.and.ii==1) write(InVar%stdout,'(a,1x,6(i4,1x),a,i4)') &
&                      'For:',iatcell,jatom,katom,watom,xatom,yatom,' direct transformation with isym=', &
&                       Isym3at(watom,xatom,yatom,1)
                    if (InVar%debug.and.ii.gt.1) write(InVar%stdout,'(a,1x,6(i4,1x),a,i4)') &
&                      'For:',iatcell,jatom,katom,watom,xatom,yatom,' transformation+permutation with isym=',&
&                       Isym3at(watom,xatom,yatom,1)
                  end do !ii 
                else  
                  if (InVar%debug) then
                    write(InVar%stdout,'(a,4(1x,i4))') &
&                     'NO SYMETRY OPERATION BETWEEN (iatom,jatom,katom) and (eatom,fatom,gatom)=',&
&                    iatcell,jatom,katom,eatom,fatom,gatom
                  end if
                end if  
              end if
            end do !gatom
          end do !fatom
        end do !eatom
      end do !katom 
    end do !jatom 
  end do !iatcell 
  Shell3at%nshell=ishell
  if (Shell3at%nshell.gt.nshell_max) then
    write(InVar%stdout,*) '  STOP : The maximum number of shells allowed by the code is:',nshell_max
    write(InVar%stdout,*) '         In the present calculation, the number of shells is:',Shell3at%nshell
    write(InVar%stdout,*) '         Action: increase nshell_max'
    MSG_ERROR('The maximum number of shells allowed by the code is reached')
  end if  


! Store all the previous quantities in a better way than in ref2at (without using too memory).
  ABI_MALLOC(Shell3at%neighbours,(natom,Shell3at%nshell))
  ABI_MALLOC(Shell3at%iatref         ,(Shell3at%nshell)); Shell3at%iatref(:)=zero
  ABI_MALLOC(Shell3at%jatref         ,(Shell3at%nshell)); Shell3at%jatref(:)=zero
  ABI_MALLOC(Shell3at%katref         ,(Shell3at%nshell)); Shell3at%katref(:)=zero
  do ishell=1,Shell3at%nshell
    do iatom=1,natom
      counter=0
      do jatom=1,natom
        do katom=1,natom
          if (ref3at(iatom,jatom,katom,4).eq.ishell) counter=counter+1
        end do  
      end do
      Shell3at%neighbours(iatom,ishell)%n_interactions=counter
      if (counter.eq.0) cycle
      ABI_MALLOC(Shell3at%neighbours(iatom,ishell)%atomj_in_shell,(counter))
      ABI_MALLOC(Shell3at%neighbours(iatom,ishell)%atomk_in_shell,(counter))
      ABI_MALLOC(Shell3at%neighbours(iatom,ishell)%sym_in_shell,(counter))
      ABI_MALLOC(Shell3at%neighbours(iatom,ishell)%transpose_in_shell,(counter))
      Shell3at%neighbours(iatom,ishell)%atomj_in_shell(:)=zero
      Shell3at%neighbours(iatom,ishell)%atomk_in_shell(:)=zero
      Shell3at%neighbours(iatom,ishell)%sym_in_shell(:)=zero
      Shell3at%neighbours(iatom,ishell)%transpose_in_shell(:)=zero
      counter=0
      do jatom=1,natom
        do katom=1,natom
          if (ref3at(iatom,jatom,katom,4).eq.ishell) then
            counter=counter+1
            Shell3at%neighbours(iatom,ishell)%atomj_in_shell(counter)=jatom
            Shell3at%neighbours(iatom,ishell)%atomk_in_shell(counter)=katom
            Shell3at%neighbours(iatom,ishell)%sym_in_shell(counter)=Isym3at(iatom,jatom,katom,1)
            Shell3at%neighbours(iatom,ishell)%transpose_in_shell(counter)=Isym3at(iatom,jatom,katom,2)
            Shell3at%iatref         (ishell)=ref3at(iatom,jatom,katom,1)
            Shell3at%jatref         (ishell)=ref3at(iatom,jatom,katom,2)
            Shell3at%katref         (ishell)=ref3at(iatom,jatom,katom,3)
          end if  
        end do  
      end do
    end do
  end do
  ABI_FREE(ref3at)
  ABI_FREE(Isym3at)

! Find the number of coefficients of the (3x3x3) Psij for a given shell
  ABI_MALLOC(Shell3at%ncoeff     ,(Shell3at%nshell)); Shell3at%ncoeff(:)=zero
  ABI_MALLOC(Shell3at%ncoeff_prev,(Shell3at%nshell)); Shell3at%ncoeff_prev(:)=zero
  write(InVar%stdout,*) ' '
  write(InVar%stdout,*) '#############################################################################'
  write(InVar%stdout,*) '############################ THIRD ORDER  ###################################'
  write(InVar%stdout,*) '################ Now, find the number of coefficients for ###################'
  write(InVar%stdout,*) '########################## a reference interaction ##########################'
  write(InVar%stdout,*) '#############################################################################'
  write(InVar%stdout,*) 'Number of shells=',Shell3at%nshell
  write(InVar%stdout,*) '============================================================================'
  open(unit=16,file='nbcoeff-psij.dat')
  ncoeff_prev=0
  do ishell=1,Shell3at%nshell
    ncoeff=0
    iatref=Shell3at%iatref(ishell)
    jatref=Shell3at%jatref(ishell)
    katref=Shell3at%katref(ishell)
    write(InVar%stdout,*) 'Shell number:',ishell 
    write(InVar%stdout,'(a,i5,a,i5,a,f16.10)') '  Between atom',iatref,' and ',jatref,' the distance is=',distance(iatref,jatref,1)
    write(InVar%stdout,'(a,i5,a,i5,a,f16.10)') '  Between atom',jatref,' and ',katref,' the distance is=',distance(jatref,katref,1)
    write(InVar%stdout,'(a,i5,a,i5,a,f16.10)') '  Between atom',katref,' and ',iatref,' the distance is=',distance(katref,iatref,1)
    call tdep_calc_nbcoeff(distance,iatref,InVar,ishell,jatref,katref,ncoeff,norder,Shell3at%nshell,order,proj,Sym)
    Shell3at%ncoeff     (ishell)=ncoeff
    Shell3at%ncoeff_prev(ishell)=ncoeff_prev
    ncoeff_prev=ncoeff_prev+ncoeff
    write(InVar%stdout,*)'  Number of independant coefficients in this shell=',ncoeff
    write(InVar%stdout,*) '============================================================================'
  end do  
  write(InVar%stdout,*)'  >>>>>> Total number of coefficients in these shells=',ncoeff_prev
  close(16)
  ntotcoeff=ncoeff_prev
  
 end subroutine

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 subroutine tdep_destroy_shell(natom,order,Shell)


!This section has been created automatically by the script Abilint (TD).
!Do not modify the following lines by hand.
#undef ABI_FUNC
#define ABI_FUNC 'tdep_destroy_shell'
!End of the abilint section

  implicit none
  integer, intent(in) :: natom,order
  type(Shell_Variables_type),intent(inout) :: Shell

  integer :: iatom,ishell

  ABI_FREE(Shell%ncoeff)
  ABI_FREE(Shell%ncoeff_prev)
  ABI_FREE(Shell%iatref)
  ABI_FREE(Shell%jatref)
  if (order.gt.2) ABI_FREE(Shell%katref)
  do iatom=1,natom
    do ishell=1,Shell%nshell
      if (Shell%neighbours(iatom,ishell)%n_interactions.ne.0) then 
        ABI_FREE(Shell%neighbours(iatom,ishell)%atomj_in_shell)
        ABI_FREE(Shell%neighbours(iatom,ishell)%sym_in_shell)
        ABI_FREE(Shell%neighbours(iatom,ishell)%transpose_in_shell)
        if (order.gt.2) ABI_FREE(Shell%neighbours(iatom,ishell)%atomk_in_shell)
      end if  
    end do  
  end do  
  ABI_FREE(Shell%neighbours)

 end subroutine

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
end module m_tdep_shell
