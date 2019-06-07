c bin_mklr_v1.0
c
c Input Arg
c   1. fni: input_file_name
c   2. fno: output_file_name
c   3. loops:  number of loop (0-999)
c            e.g.. daily: 366, monthly: 12...
c
c Parameter
c  num_lim : limit of number of data  (default is 1)
c----------------------------------------------------------------------- 
      implicit none
      integer nd, nloop, num_lim
      integer i,j,ix,jy
      integer i2,j2,ix2,jy2
      integer is,ie,js,je
      real spv
      parameter(ix=1440,jy=720,ix2=360,jy2=180)
      parameter(spv=-9999.0, num_lim=1)
      real data(ix,jy),data2(ix2,jy2)
      real sum(ix2,jy2)
      integer num(ix2,jy2)
      character loops*100
      character*100 fni,fno

      call getarg(1,fni)
      call getarg(2,fno)
      call getarg(3,loops)
      read(loops,'(i3)') nloop
c      fno="output.bin"

c      write(6,*) " Input: ", fni
c      write(6,*) "Output: ", fno
c      write(6,*) "  Loop: ", nloop

c Standard output
      write(6,*) fno

      open(51,file=fni,form="unformatted")
      open(61,file=fno,form="unformatted")

      DO 5 nd=1,nloop

c READ HR data     
      do j=1,jy
       read(51,end=888) (data(i,j),i=1,ix)
      enddo

c INIT.
      do i2=1,ix2
       do j2=1,jy2
         data2(i2,j2)=spv
         sum(i2,j2)=0.0
         num(i2,j2)=0
       enddo
      enddo

c SUM
      do 10 i2=1,ix2
       ie=i2*4
       is=ie-3
       do 20 j2=1,jy2
            je=j2*4
            js=je-3
        do i=is,ie
         do j=js,je
          if (data(i,j).ne.spv) then
           sum(i2,j2)=sum(i2,j2)+data(i,j)
           num(i2,j2)=num(i2,j2)+ 1
          endif
         enddo
        enddo
 20    continue
 10   continue


c AVE
      do i2=1,ix2
       do j2=1,jy2
        if(num(i2,j2).ge.num_lim) then
         data2(i2,j2)=sum(i2,j2)/real(num(i2,j2))
        else
         data2(i2,j2)=spv
        endif
       enddo
      enddo

c Output LR data
      do j2=1,jy2
       write(61)(data2(i2,j2),i2=1,ix2)
      enddo

 5    CONTINUE

 888  continue
c      write(6,*) "End of data"
 999  continue
c      write(6,*) "End of program"


      stop
      end

      
