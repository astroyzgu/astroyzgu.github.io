## Fortran基础

###### 子程序传递数组

``` Fortran 
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
``` 

```
INTENT属性的格式如下：

INTENT(IN)，形参仅用于向子程序传递输入数据；
INTENT(OUT)，形参仅用于将结果返回给调用程序；
INTENT(INOUT) 或 INTENT(IN OUT)，形参既用来向子程序输入数据，也用来向调用程序返回结果
```
 
``` Fortran 
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
```

##### 动态库(.so)和静态库(.a)

`xxx.so是动态函数库`

对于动态函数库(优先)，在运行执行文件时，仍需要从.so库文件中读取函数信息。

`xxx.a是静态函数库`

对于静态函数库在编译的时直接整合到可执行文件，程序可以独立运行的。 

###### Fortran程序的简单编译： 
  gfortran -o hello_world hello_world.f

###### 在编译过程中调用外部函数库： 
  gfortran -o hello_world hello_world.f -lxxx -L/path/to/lib -I/path/to/head 
调用xxx库函数, -lxxx(-l是lib的意思，xxx为库名)
库文件的位置由 -L 后的路径给出。 
头文件则从 -I 后的路径里去找。

###### 在环境变量中提供动态库文件的位置
执行编译好的可执行文件hello_world

   `./hello_world`

执行可能会报错错误，是因为编译是用到了libxxx.so, 运行时得再次访问。
在环境变量（.bashrc）中提供动态库文件所在的位置。

   `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/lib`

###### 自定义库函数文件
将源文件编译为xxx.o目标文件: 

  `gfortran -c xxx.f` 

产生的xxx.o文件即为目标文件(目标文件指源代码经过编译程序产生的且能被cpu直接识别二进制代码)。再将目标文件编译成可执行文件：

  `gfortran -o xxx xxx.o` 

函数库就是将很多xxx.o 和在一起形成的。 

  `gfortran -fPIC -shared -o libxxx.so xxx.f` 

调用刚刚生成的函数库

  `gfortran -o run run.f -lxxx -L./`

###### 参考

1. https://blog.csdn.net/weixin_43880667/article/details/84836145

2. https://www.yiibai.com/fortran/fortran_intrinsic_functions.html 
