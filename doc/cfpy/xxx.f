c----   子程序传递数组：指明形参数组的大小的三种方式 

c---    方式1. 数组的维度大小作为参数进行传递, j1, j2, j3

        subroutine sub1(y1, y2, y3, j1, j2, j3)  
	IMPLICIT NONE
        INTEGER, INTENT(IN)  :: j1, j2, j3 
        REAL,    INTENT(OUT) :: y1(j1), y2(j1, j2), y3(j1, j2, j3)
        y1 = 1
        y2 = 2
        y3 = 3
        return 
	end subroutine sub1

c---    方式2. 形参数组声明为不定结构，需要显式接口（MODULE or interface）

        MODULE mymodule ! 显式接口
        CONTAINS
                subroutine sub2(y1, y2, y3) 
		IMPLICIT NONE
                REAL , INTENT(OUT) ::y1(:)
                REAL , INTENT(OUT) , DIMENSION(:,:)::y2
                REAL , INTENT(OUT) , DIMENSION(:,:,:)::y3
                y1 = 1
                y2 = 2
                y3 = 3
                return 
 	       end subroutine sub2 
	END MODULE mymodule


       	subroutine sub3(y1, y2, y3) 
        REAL , INTENT(OUT) ::y1(:), y2(:,:), y3(:,:,:)
	y1 = 1
	y1 = 2
	y1 = 3
 	end subroutine sub3


c----   main program 

        PROGRAM main         

        use mymodule
	IMPLICIT NONE
	integer(4) :: i, i1, i2, i3
	real(4)    :: x, x1(2), x2(2,2), x3(2,1,2)

c---------------------------------------------------------------
	interface
        	subroutine sub3(y1, y2, y3) 
        	REAL , INTENT(OUT) ::y1(:), y2(:,:), y3(:,:,:)
 		end subroutine sub3
	end interface
c---------------------------------------------------------------

        ! 调用函数， 需要传递的是数组的指针和大小
        call sub1(x1, x2, x3, 2, 1, 1) ! 方式1

        ! 注意由于传递的是指针，数组大小的定义不一样也可以传递
	write(*,*) 'call sub1'
  	write(*,*) 'shape x3:', shape(x3)
  	write(*,*) 'x3:',  x3  

	write(*,*) ''
	write(*,*) 'call sub2 or sub3'
        call sub2(x1, x2, x3)          ! 方式2 
        call sub3(x1, x2, x3)          ! 方式2 
  	write(*,*) 'x1:', x1
  	write(*,*) 'x2:', x2 
  	write(*,*) 'x3:', x3 

        STOP 
        END 
