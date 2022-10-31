c------ 方法1 先维度，再数据
	subroutine sub1(i1, i2, i3)  
        INTEGER, INTENT(OUT) :: i1, i2, i3 
        i1 = 2
        i2 = 2
        i3 = 2
	end subroutine sub1

        subroutine sub2(x1, x2, x3, i1, i2, i3) 
        INTEGER, INTENT(IN) :: i1, i2, i3 
        real, INTENT(OUT) :: x1(i1), x2(i1,i2), x3(i1,i2,i3)
        x1 = 1
        x2 = 2
        x3 = 3
	end subroutine sub2

        subroutine sub3(x1, x2, x3) 
        real, allocatable :: x1(:), x2(:,:), x3(:,:,:)
        x1 = 1
        x2 = 2
        x3 = 3
	end subroutine sub3
	
        PROGRAM main         

	IMPLICIT NONE
	interface 
	        subroutine sub3(x1, x2, x3) 
       		!INTEGER :: i1, i2, i3 
        	real, allocatable :: x1(:), x2(:,:), x3(:,:,:)
		end subroutine sub3
	end interface 

	integer(4) :: i1, i2, i3
        common/shape/i1, i2, i3

        real(4), allocatable :: x1(:), x2(:,:), x3(:,:,:)
        call sub1(i1, i2, i3)
        allocate( x1(i1), x2(i1,i2), x3(i1,i2,i3) ) 
        call sub2(x1, x2, x3, i1, i2, i3)           
        ! or 
        call sub3(x1, x2, x3)           
  	write(*,*) 'x1:', x1 
  	write(*,*) 'x2:', x2 
  	write(*,*) 'x3:', x3 

        STOP 
        END 
