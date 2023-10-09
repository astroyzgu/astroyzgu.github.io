# setuptools

`` BIND(C [, NAME=scalar-default-char-constant-expr]) ``

The bind(c) means that the function is C-function, so a compiler must formalize its call in the C language. The optional NAME= specifier allows you to use a different external name than the one the standard prescribes. 

``` Fortran
	subroutine hello_world() 
     &  bind(c, name = 'c_hello_world')
        use iso_c_binding
        implicit none
	write(*,*)'c hello_world'
	END subroutine 
```




### Makefile 

``` Makefile 
.PHONY: test build

CC=gcc 
CFLAG= -g -Wall -O
F2PY=f2py
F2PYFLAG= -c -m 

PWD_DIR=$(PWD)#这里是执行shell的pwd命令获取路劲作为PWD_DIR参数
SRC_DIR=$(PWD_DIR)/src
OBJ_DIR=$(PWD_DIR)/obj
MAIN_DIR=$(PWD_DIR)/main
LIB_DIR=$(PWD_DIR)/lib
INC_DIR=$(PWD_DIR)/inc

# c [ctypes + mypkg/__init__.py ] 
CLIB1_DIR=$(PWD_DIR)/mypkg/src/clib1/ 

# fortran [f2py] 
FLIB1_DIR=$(PWD_DIR)/mypkg/src/flib1/

# [f+c+python] 
CFPY_DIR=$(PWD_DIR)/mypkg/src/cfpy/

test: 
	@echo 'testing clib1'
	python test/test_clib1.py 
	@echo 'testing fsub1 (f2py)'
	python test/test_flib1.py 

build:
	@mkdir -p bin


clean:
	rm -rf *.out *.bin *.exe *.o *.a *.so build

``` 


``` python 
from numpy.distutils.core import Extension, setup
ext1 = Extension(name = 'scalar',
                 sources = ['scalar.f'])
ext2 = Extension(name = 'fib2',
                 sources = ['fib2.pyf','fib1.f'])

setup(name = 'f2py_example', ext_modules = [ext1,ext2])
```

### fortran part  

**sub1.f** 基础调用
**sub2.f** 利用ctypes调用
```
	python build.py #==> libplugin.so
	gfortran -o ./run -L./ -lplugin main2.f xxx.f
	gfortran -shared -o flib2.so -L./ -lplugin main2.f xxx.f

	gcc -c -fPIC clib1.c -o clib1.o
	gfortran -shared fmod1.f clib1.o -o cflib.so
	python test_sub2.py
```

### Fortran存档
**sub1.f** 基础调用

``` FORTRAN90
c------- 最简单的调用
        subroutine hello_world()
        write(*,*) 'hello world'
        end subroutine hello_world

c------- 有输入和返回的函数
        subroutine euclidian_norm(a,c,n)
        integer :: n
        real(8),dimension(n),intent(in) :: a
        !f2py optional, depend(a) :: n=len(a)
        real(8),intent(out) :: c
        real(8) :: sommec
        integer :: i
        sommec = 0
        do i=1,n
          sommec=sommec+a( i )*a( i )
        end do
        c = sqrt (sommec)
        end subroutine euclidian_norm

c------- 含有omp的调用
        subroutine hello_omp()
        use omp_lib
        integer :: i
        !$OMP PARALLEL PRIVATE(I)
        !$OMP DO 
        do i = 1, 4
          call sleep(1)
        end do
        !$OMP END DO
        !$OMP END PARALLEL
        write(*,*)'hello_omp'
        end subroutine hello_omp

c------- 输入和返回numpy数组
        subroutine push(positions, velocities, dt, n, new_positions)
        integer, intent(in) :: n
        real(8), intent(in) :: dt
        real(8), dimension(n,3), intent(in) :: velocities
        real(8), dimension(n,3) :: positions
        real(8), dimension(n,3), intent(out) :: new_positions
        do i = 1, n
          positions(i,:) = positions(i,:) + dt*velocities(i,:)
        end do
        new_positions = positions 
        end subroutine push
```

**sub2.f** 利用ctypes调用

``` FORTRAN
c------- fortran转为c语言接口（最后通过ctypes调用）
        subroutine sub(x, i, N) bind(c, name = 'subname_in_py')  
        use iso_c_binding !fortran自带的, 必须加载!
	implicit none 
        integer(c_long), intent(in), value   :: N  
        real(c_double),  intent(inout)       :: x(N)
        integer(c_long), intent(inout)       :: i(N)
        write(*,*) x  
        write(*,*) i 
        write(*,*) N 
        x  = exp(x)  
        i  = i + 1  
        end subroutine sub 

c------- fortran转为c语言接口（最后通过ctypes调用）
	subroutine hello_world(i, xf, xd, N) 
     &  bind(C, name = 'c_hello_world')
        use iso_c_binding
	implicit none 
        integer(c_int), intent(in), value   :: i
        integer(c_int), intent(in), value   :: N
        real(c_float),  intent(inout)   :: xf(N)
        real(c_double),  intent(inout)  :: xd(N)

	write(*,*)'hello world'
	write(*,*) 'integer(c_int), i', i 
	write(*,*) 'integer(c_int), N', N 
	write(*,*) 'real(c_float),  xf(N)', xf
	write(*,*) 'real(c_double), xd(N)', xd
	end subroutine hello_world

c------- 调用c语言接口（最后通过ctypes调用）
	subroutine push(positions, velocities, dt, n) 
     &  bind(C, name="f_push_particles")

        use iso_c_binding
	integer, intent(in) :: n
	real(8), dimension(n),  intent(in)  :: positions
	real(8), dimension(n),  intent(in) :: velocities
	real(8), intent(in) :: dt

	interface
	   subroutine c_push_particles(positions, velocities, dt, n) 
     &  bind(C, name="push_particles")
	   integer, intent(in) :: n
	   real(8), dimension(n),  intent(in)  :: positions
	   real(8), dimension(n),  intent(in) :: velocities
	   real(8), intent(in) :: dt
	   end subroutine c_push_particles
	end interface
	
	call c_push_particles(positions, velocities, dt, n)

	end subroutine push

c------- python通过cffi转换c语言接口，最后通过ctypes调用
        subroutine loaddata(snap, x_out, Nout)
        use iso_c_binding ! 和C语言类型互通的模块iso_c_binding
        implicit none 
        interface  
         subroutine c_sharedata32(snap, x_out, Nout) 
     &   bind (c, name = 'sharedata32')
             use iso_c_binding    
             integer(c_long), intent(in)       :: snap(1) 
             integer(c_long), intent(in)       :: Nout(1)
             real(c_double),  intent(inout)    :: x_out(Nout(1) ) 
         end subroutine c_sharedata32
        end interface
        integer(c_long) :: snap, Nout
        real(c_double) :: x_out(Nout)
        integer(c_long) :: snap0(1), Nout0(1)
	snap0(1) = snap  
        Nout0(1) = Nout
        call c_sharedata32(snap0(1), x_out, Nout0(1) ) 
	snap = snap0(1)
        Nout = Nout0(1) 
	end subroutine loaddata
```

### c程序存档

**sub2.f** 配套

``` c
"""==================== %%file csub2.c ========================="""
#include <stdio.h>
int add(int a, int b)
{
    return a + b;
}

//extern "C" double multiply(double, double)

// Python、Java支持调用C接口，
// 不支持调用C++接口，因此对于C++语言实现的接口，必须转换为C语言实现。
// 为了不修改原始C++代码，在C++接口上层用C语言进行一次封装

double multiply(double a, double b) 
{
    return a*b;
}

void push_particles(double* positions, double* velocities, double dt, int n){
    int i;
    for (i=0; i<n; i++){
       positions[i] = positions[i] + dt * velocities[i];
    }
}
``` 

### python存档

```

import ctypes
import numpy as np
from ctypes import * 
from numpy.ctypeslib import load_library, ndpointer


cflib     = ctypes.cdll.LoadLibrary("cflib.so")

#
#--- 传入numpy数据ctypes.data_as 
#
def c_hello_world(i, xf, xd):  
    xf = np.array(xf).astype('float32')
    xd = np.array(xd).astype('float64')
    cflib.c_hello_world.argtype = [
              c_int, 
              POINTER(c_float), 
              POINTER(c_double), 
              c_int]
    N = len(xf)
    print(xf) 
    print(xd) 
    print(N) 
    xf_ptr = xf.ctypes.data_as(POINTER(c_float)) 
    xd_ptr = xd.ctypes.data_as(POINTER(c_double))  
    cflib.c_hello_world(c_int(i), xf_ptr, xd_ptr, c_int(N) ) 

def subname_in_py(x, i, N): 
    x = np.array(x).astype('float64')
    i = np.array(i).astype('int64')
    cflib.subname_in_py.argtype = [ 
             POINTER(c_double), 
              POINTER(c_long), 
              c_long]  
    x_ptr = x.ctypes.data_as(POINTER(c_double)) 
    i_ptr = i.ctypes.data_as(POINTER(c_long)) 
    cflib.subname_in_py( x_ptr, i_ptr, c_long(N) )
```





### old 

```
"""==================== %%file fmod.f90 ========================="""

module fmod
    use iso_c_binding
    implicit none

contains

    function multiply(a, b) result(res)
        real(8) :: a, b, res   !! "8" just for test
        interface
            real(c_double) function c_multiply(a, b) bind(C,name="multiply")
                import
                real(c_double), value :: a,b
            end
        end interface

        res = c_multiply(a, b)
    end

    subroutine push_particles(positions, velocities, dt, n) 
        integer, intent(in) :: n        
        real(8), dimension(n),  intent(inplace)  :: positions 
        real(8), dimension(n),  intent(in) :: velocities
        real(8), intent(in) :: dt
        interface
            subroutine c_push_particles(positions, velocities, dt, n) bind(C,name="push_particles")
                import
                integer, intent(in) :: n        
                real(8), dimension(n),  intent(inplace)  :: positions 
                real(8), dimension(n),  intent(in) :: velocities
                real(8), intent(in) :: dt
            end c_push_particles 
        end interface

 	call c_push_particles(positions, velocities, dt, n) 

    end subroutine push_particles


end module



"""==================== %%file cfuncts.pyf ========================="""
python module cfuncts 
    interface
        subroutine push_particles(positions, velocities, dt, n) 
            intent(c):: push_particles
            intent(c)
            integer, optional, depend(velocities) :: n = len(velocities)
            real(8), dimension(n),  intent(inplace)  :: positions 
            real(8), dimension(n),  intent(in) :: velocities
            real(8), intent(in) :: dt
        end subroutine push_particles
    end interface
end python module cfuncts


gcc -c -fPIC clib.c -o clib.o
f2py -c fmod.f90 clib.o -m py_fmod

python main2.py 
"""==================== %%file prog2.py  ========================="""
import numpy as np
import py_fmod

n = 10
dt = 0.1
x = np.arange(n, dtype="d")
v = np.ones(n, dtype="d")
py_fmod.push_particles(x, v, dt)
print(x)
```

**sub2.f** for calling python program
``` fortran  
        subroutine loaddata1(data1, N1, N2, data2)
        use, intrinsic :: iso_c_binding ! 和C语言类型互通的模块iso_c_binding
        implicit none 
        integer, intent(in) :: N1, N2
        real(8), dimension(N1,N2), intent(in)  :: data1
        real(8), dimension(N1,N2), intent(out) :: data2
	do i1=1,N1
	   do i2=1,N2
	      data2(i1, i2) = i1 + i2
	   enddo
	enddo
	write(*,*)'sub2 loaddata1'
        end subroutine loaddata1

        subroutine loaddata2(data1, N1, N2, data2)
        use, intrinsic :: iso_c_binding ! 和C语言类型互通的模块iso_c_binding
        implicit none 
        integer, intent(in) :: N1, N2
        real(8), dimension(N1,N2), intent(in)  :: data1
        real(8), dimension(N1,N2), intent(out) :: data2
	do i1=1,N1
	   do i2=1,N2
	      data2(i1, i2) = i1 + i2
	   enddo
	enddo
	write(*,*)'sub2 loaddata2'
        end subroutine loaddata2

```

``` python
import numpy as np  
def sharedata(): 
    return np.array([1,2,3])
```

**start.f** as main program

### python part

**call** subroutines from sub1.f through main.py  
``` shell 

module load compiler/intel-2018
module load anaconda
source activate python3

f2py -c -m myflib sub1.f --f90flags='-fopenmp' -lgomp
python main1.py 
```



``` python 
#---------------------- main.py ----------------------------#
mport myflib
import logging
import numpy as np
import matplotlib.pyplot as plt
import itertools
logger = logging.getLogger()
logger.setLevel(logging.DEBUG)
 
#------------------------------------------------------------
myflib.hello_world()
logger.info('正在执行主程序, 子程序hello_world(sub1.f)正常')
 
#------------------------------------------------------------
a = np.array([3,4,5])
c = myflib.euclidian_norm(a)
print('input:', a, type(a))
print('output:', c, type(c))
logger.info('正在执行主程序, 子程序euclidian_norm(sub1.f)正常')
 
 
#------------------------------------------------------------
myflib.hello_omp()
logger.info('正在执行主程序, 子程序hello_omp(sub1.f)正常')
 
positions  = [[0, 0, 0], [0, 0, 0], [0, 0, 0]]
velocities = [[0, 1, 2], [0, 3, 2], [0, 1, 3]]
new_positions = myflib.push(positions, velocities, 0.1)
print(new_positions)
print('END')
```

