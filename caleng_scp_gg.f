c     ==================================================
      subroutine caleng(com_1, com_2, E_2H2O,
     +                    Eulang_1, Eulang_2)
c     ==================================================
c     Initially:
c     __________________________________________________
c     this subroutine calculates TIP4P potential between
c     two rigid waters given the coordinates
c     of their centres of mass and 
c     their respective Euler angles
c     e: com1, com2, rotmat1, rotmat2
c        ROwf, R1wf, R2wf, RMwf
c     s: E2H2O
c     __________________________________________________
c     GG (Dec. 16th 2011):   -----> H2O ---- H2O SCP
c     __________________________________________________
c     rotmat_1, rotmat_2 computed within the code with 
c     Eulang_1, Eulang_2
c     ROwf, RH1wf, RH2wf, RMwf put as data   
c     e: com_1, com_2, Eulang_1, Eulang_2
c     s: E_2H2O 
      implicit double precision(a-h,o-z)
      parameter(zero=0.d0)
      dimension ROwf(3), RH1wf(3), RH2wf(3), RMwf(3),
     +          com_1(3), com_2(3), Eulang_1(3),
     +          Eulang_2(3), RO_1_sf(3), RO_2_sf(3),
     +          RH1_1_sf(3), RH1_2_sf(3),
     +          RH2_1_sf(3), RH2_2_sf(3),
     +          RM_1_sf(3), RM_2_sf(3), vec(3),
     +          rotmat_2(3,3), rotmat_1(3,3), 
     +          crossA(3), crossB(3)
c     TIP4P parameters (L-J) & conversion factors: 
      parameter(epsoo=0.154875717017208413d0,sigoo=3.15365d0,
     +          qo=-1.04d0,qh=0.520d0,
     +          br2ang=0.52917721092d0,hr2kcl=627.509469d0,
     +          hr2k=3.1577465d5,kcal2k=503.218978939)
      data ROwf/zero,zero,0.06562d0/,RH1wf/0.7557d0,zero,-0.5223d0/,
     +     RH2wf/-0.7557d0,zero,-0.5223d0/
c     
c     print*,'com_1',(com_1(i),i=1,3)
c     print*,'com_2',(com_2(i),i=1,3)
c     prepare rotational matrix for water 1
c     obtain the SFF coordinates for H1, H2, and O of water 1
      call matpre(Eulang_1, rotmat_1)
      do i=1,3
         RO_1_sf(i)=0.d0
      enddo
c     call DGEMV ('N', 3, 3, 1.d0, rotmat_1, 3, ROwf, 1, 1.d0, RO_1_sf, 1 )
      call rottrn(rotmat_1, ROwf, RO_1_sf, com_1)
c
      do i=1,3
         RH1_1_sf(i)=0.d0
      enddo
c     call DGEMV ('N', 3, 3, 1.d0, rotmat_1, 3, R1wf, 1, 1.d0, R1_1_sf, 1 )
      call rottrn(rotmat_1, RH1wf, RH1_1_sf, com_1)
c
      do i=1,3
         RH2_1_sf(i)=0.d0
      enddo
c     call DGEMV ('N', 3, 3, 1.d0, rotmat1, 3, R2wf, 1, 1.d0, R21sf, 1 )
      call rottrn(rotmat_1, RH2wf, RH2_1_sf, com_1)
c
c     prepare rotational matrix for water 2
c     obtain the SFF coordinates for H1, H2, and O of water 2
      call matpre(Eulang_2, rotmat_2)
      do i=1,3
         RO_2_sf(i)=0.d0
      enddo
c     call DGEMV ('N', 3, 3, 1.d0, rotmat_2, 3, ROwf, 1, 1.d0, RO_2_sf, 1 )
      call rottrn(rotmat_2, ROwf, RO_2_sf, com_2)
c
c     call rottrn(rotmat2,R1wf,R12sf,com2)
      do i=1,3
         RH1_2_sf(i)=0.d0
      enddo
c     call DGEMV ('N', 3, 3, 1.d0, rotmat2, 3, R1wf, 1, 1.d0, R12sf, 1 )
      call rottrn(rotmat_2, RH1wf, RH1_2_sf, com_2)
c
c     call rottrn(rotmat2,R2wf,R22sf,com2)
      do i=1,3
         RH2_2_sf(i)=0.d0
      enddo
c     call DGEMV ('N', 3, 3, 1.d0, rotmat2, 3, R2wf, 1, 1.d0, R22sf, 1 )
      call rottrn(rotmat_2, RH2wf, RH2_2_sf, com_2)
c
c ... calculate water dimer energies through SPC/WF formula
      E_2H2O=0.d0
c ... O-O interaction
      roo=0.0d0
      rMM=0.0d0
      do i=1,3
        roo=roo+(RO_1_sf(i)-RO_2_sf(i))*(RO_1_sf(i)-RO_2_sf(i))
      enddo
      roo4=roo*roo
      roo6=roo4*roo
      roo12=roo6*roo6
      roo=sqrt(roo)
c     AMBER values: 
c     A_param=5.99896595E+05
c     B_param=6.09865468E+02
c     SPC values:
      A_param=6.d5
      B_param=610.d0
c     TIP4P values:
c     A_param=6.d5
c     B_param=610.d0
      o2lj=A_param/roo12-B_param/roo6
c ... H-O, H-H and O-O Columbic interaction
      rho1=0.0
      rho2=0.0
      rho3=0.0
      rho4=0.0
      rhh1=0.0
      rhh2=0.0
      rhh3=0.0
      rhh4=0.0
      do i=1,3
        rho1=rho1+(RO_1_sf(i)-RH1_2_sf(i))*(RO_1_sf(i)-RH1_2_sf(i))
        rho2=rho2+(RO_1_sf(i)-RH2_2_sf(i))*(RO_1_sf(i)-RH2_2_sf(i))
        rho3=rho3+(RO_2_sf(i)-RH1_1_sf(i))*(RO_2_sf(i)-RH1_1_sf(i))
        rho4=rho4+(RO_2_sf(i)-RH2_1_sf(i))*(RO_2_sf(i)-RH2_1_sf(i))
        rhh1=rhh1+(RH1_1_sf(i)-RH1_2_sf(i))*(RH1_1_sf(i)-RH1_2_sf(i))
        rhh2=rhh2+(RH1_1_sf(i)-RH2_2_sf(i))*(RH1_1_sf(i)-RH2_2_sf(i))
        rhh3=rhh3+(RH2_1_sf(i)-RH1_2_sf(i))*(RH2_1_sf(i)-RH1_2_sf(i))
        rhh4=rhh4+(RH2_1_sf(i)-RH2_2_sf(i))*(RH2_1_sf(i)-RH2_2_sf(i))
      enddo
      rho1=sqrt(rho1)
      rho2=sqrt(rho2)
      rho3=sqrt(rho3)
      rho4=sqrt(rho4)
      rhh1=sqrt(rhh1)
      rhh2=sqrt(rhh2)
      rhh3=sqrt(rhh3)
      rhh4=sqrt(rhh4)
c     print*,'rho1 rho2 rho3 rho4',rho1, rho2, rho3, rho4 
c     print*,'rhh1 rhh2 rhh3 rhh4',rhh1, rhh2, rhh3, rhh4 
c
c ... ohcolm is the coulumbic term between O and H from different H2O in the unit of Hartree
      ohcolm=qo*qh*(1.d0/rho1+1.d0/rho2+1.d0/rho3+1.d0/rho4)
c ... hhcolm is ... between H and H ...
      hhcolm=qh*qh*(1.d0/rhh1+1.d0/rhh2+1.d0/rhh3+1.d0/rhh4)
c ... oocolm is ... between O and O ...
      oocolm=qo*qo*(1.d0/roo)
c
      E_2H2O=o2lj*kcal2k+(ohcolm+oocolm+hhcolm)*hr2k*br2ang
c     print*,'E_2H2O=',E_2H2O
c     E_2H2O=zero
c
      return
      end
