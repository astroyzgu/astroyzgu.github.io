# python调用fortran

[python调用fortran的3种形式【f2py，动态链接库，os命令】](https://blog.csdn.net/weixin_43585712/article/details/122475968)

[Python调用C/Fortran混合的动态链接库](https://blog.csdn.net/weixin_30488085/article/details/98787832)


#### f2py 


```  
"""====================1.fortran程序========================="""
function foo(a) result(b)
    !kind说明精度
    implicit none
    real(kind=8), intent(in)    :: a(:,:)
    complex(kind=8)             :: b(size(a,1),size(a,2))
    b = exp((0,1)*a)
end function foo

"""=============2.编译fortran程序，生成动态链接库==============="""
f2py -c -m myflib testfun.f90 
#myflib为包名，testfun.f90为上面fortran代码
#在cmd输入上面的命令

"""=============3.在python中通过import引入动态链接库============"""
import myflib
import numpy as np
a = np.array([[1,2,3,4], [5,6,7,8]], order='F')
print(myflib.foo(a))
``` 

#### ctypes&numpy 


| fortran  |  numpy     |  c     | comment                  |
|----------|------------|--------|--------------------------|
| int*4    |  int32     | int    | -2147483648, 2147483647  | 
| real*4   |  float32   | float  | 有效数字为 6-7, 数值范围为 -3.4E+38～3.4E+38 |
| int*8    |  int64     | long   |                          | 
| real*8   |  float64   | double |                          |

! [//]:(char*256  <class 'str'>   字符串  需小于256个字符)
```
"""====================1.fortran程序========================="""
        ! iso_c_bindings c和fortran函数返回类型不能是数组
        ! 数组的计算在fortran中通过subroutine实现 
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
"""=============2.编译fortran程序，生成动态链接库==============="""
gfortran -shared testfun.f90 -o myflib_ctype.so 
myflib_ctype为包名，testfun.f90为上面fortran代码
在cmd输入上面的命令
"""=============3.通过ctyps和numpy完成在python中调用============"""
# 在python中可以通过ctyps将numpy的数组地址，类型和维度信息传入 
from ctypes import POINTER, c_int, c_double, c_long, CDLL 
from numpy.ctypeslib import load_library, ndpointer 
import numpy as np  
# 载入方式一 
myflib = load_library("myflib_ctype.so","./")
# 载入方式二
myflib = CDLL("myflib_ctype.so")

# 导入动态库中的函数subname_in_py，指定输入类型
f      = myflib.subname_in_py
f.argtype = [ POINTER(c_double), 
              POINTER(c_long), 
              c_long]   

ddata = np.log([1,2,3,4,5,6],   dtype = 'f8') # 对应real*8 
idata = np.array([1,2,3,4,5,6], dtype = 'i8') # 对应int*8
N = 6  
# NumPy的ndarray提供了ctypes模块，可以调用其data属性将数组首地址传入 
x_ptr = ddata.ctypes.data_as(POINTER(c_double)) 
i_ptr = idata.ctypes.data_as(POINTER(c_long))  
f(x_ptr, i_ptr, c_long(N) )
print("Fortran中" + str(f.__name__)+"函数输出:")
print('dataout:', ddata.dtype, ddata)
print('dataout:', idata.dtype, idata)

```

#### os命令 

``` python 
! 通过os.system(“cmd”) 调用外部命令
! 无法交互， 只能返回0（运行正常），1（运行异常）
import os
os.system(r"gfortran  C:/fortranDM/test.f90")
```

