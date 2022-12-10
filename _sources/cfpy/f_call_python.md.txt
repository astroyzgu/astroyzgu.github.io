# Fortran call python function

代码主要分为两步: 
1. <a href="#python部分">python部分</a> 
   CFFI, 将python程序转为C类型的打包接口， 基本可以直接和任何C代码交互。通过numpy和cffi指定数组的地址，类型和大小来实现共享内存（因此，数据的接口都是数组，常数的接口也是一个元素的数组）。 
2. <a href="#Fortran部分">Fortran部分</a>  : 利用Fortran与C语言类型互通的模块iso_c_binding, 在fortran用调用生成好的C接口。

<span id="python部分"></span>
###### python 

```python  
#======1. 准备要调用的python程序, myfunc.py====================================
import matplotlib.pyplot as plt 
import numpy as np 
def sharedata32():   
    arr1 = np.array([1.1, 2.2, 3.3, 4.4], dtype = 'f4')  
    arr2 = np.array([1, 2, 3, 4], dtype = 'i4') 
    const1 = 2.3
    const2 = 4 
    str1   = 'share data'
    str2   = 'c'*25
    return arr1, arr2, const1, const2, str1, str2
 
def scatter2d(arr1, arr2): 
    plt.scatter(arr1, arr2)
    plt.show() 
#======2.利用ffi包装成C类型的打包接口，mymodule.py==================
from my_plugin import ffi
import numpy as np
import myfunc 
from numpy import dtype 
ctype2dtype = {'uint8_t': dtype('uint8'), 'int': dtype('int32'), 'long': dtype('int64'), 'double': dtype('float64'), 'int32_t': dtype('int32'), 'float': dtype('float32'), 'int8_t': dtype('int8'), 'int16_t': dtype('int16'), 'uint32_t': dtype('uint32'), 'int64_t': dtype('int64'), 'uint64_t': dtype('uint64'), 'uint16_t': dtype('uint16')}

def asstring(ffi, ptr, length = 256): 
    string_bytes = ffi.string( ptr[0:length])
    string_ = str( string_bytes, encoding='UTF-8') 
    string_ = string_.rstrip()
    return string_ 

def asarray(ffi, ptr, shape, **kwargs):
    length = np.prod(shape)
    # Get the canonical C type of the elements of ptr as a string.
    T = ffi.getctype(ffi.typeof(ptr).item) 
    print(T)
    if T not in ctype2dtype:
        raise RuntimeError("Cannot create an array for element type: %s" % T) 
    a = np.frombuffer(ffi.buffer(ptr, length * ffi.sizeof(T)), ctype2dtype[T])\
          .reshape(shape, **kwargs) 
    return a

@ffi.def_extern() 
def sharedata32(snap, arr1, narr1 ):
    x, arr2, const1, const2, str1, str2 = myfunc.sharedata32() 
    snap    = asarray(ffi, snap, 1)[0]
    narr1   = asarray(ffi, narr1, 1)
    arr1    = asarray(ffi, arr1, narr1 )
    narr1[:]= len(x)
    arr1[:len(x)] = x
#======3. 为C类型的接口定义头文件, plugin.h ========================
extern  void sharedata32( long *, double *, long *); 

#======4. build.py, 将python程序转为C类型的打包接口================= 
import cffi  
ffibuilder = cffi.FFI() # 声明了外部函数接口(FFI)对象

with open('mymodule.py') as file_obj:
     content = file_obj.read()
module = content

with open('plugin.h') as file_obj:
     header  = file_obj.read()

ffibuilder.embedding_api(header)
ffibuilder.set_source("my_plugin", r'''
    #include "plugin.h"
''')

ffibuilder.embedding_init_code(module)
ffibuilder.compile(target= "libplugin.dylib", verbose=True)
ffibuilder.compile(target= "libplugin.so", verbose=True)

#======5. 生成动态链接库 =================
python build.py
# libplugin.dylib for macos  
# libplugin.so for linux 
export PYTHONPATH=$PYTHONPATH:$pwd
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$pwd  # 将库文件的路径添加进来
```

<span id="Fortran部分"></span>
###### Fortran部分

``` Fortran 
#===== 1. 在fortran中调用生成好的C接口, xxx.f ======================
        subroutine loaddata(snap, x_out, Nout)

        use, intrinsic :: iso_c_binding ! 和C语言类型互通的模块iso_c_binding

        implicit none 

        interface  
         subroutine sharedata32(snap, x_out, Nout) bind (c)
             use iso_c_binding    
             integer(c_long), intent(in)       :: snap(1) 
             integer(c_long), intent(in)       :: Nout(1)
             real(c_double),  intent(inout)    :: x_out(Nout(1) ) 
         end subroutine sharedata32
        end interface

        integer(c_long) :: snap, Nout
        real(c_double) :: x_out(Nout)
        integer(c_long) :: snap0(1), Nout0(1)
	snap0(1) = snap  
        Nout0(1) = Nout
        call sharedata32(snap0(1), x_out, Nout0(1) ) 
	snap = snap0(1)
        Nout = Nout0(1) 
        return 
	end subroutine loaddata
#======= 2.编写主程序main.f
	PROGRAM main
        use, intrinsic :: iso_c_binding ! 和C语言类型互通的模块iso_c_binding
        implicit none
 

        integer(c_long) :: Nin, Noutmax, snap 
        real(c_double), allocatable :: x_in(:), x_out(:)
        Nin  = 10 

c---    readin subhalo information 

        snap    = 127 
        Noutmax = 10 
        allocate( x_out(Noutmax) )  
        call loaddata( snap, x_out, Noutmax )  
        !call sharedata32( snap, x_out, Noutmax )  
        write(*,*) x_out 
        write(*,*) snap
        write(*,*) Noutmax

        END

#===== 2. 编译，链接到动态链接库libplugin.so =================
gfortran -ffixed-line-length-132 -o ./main -L./ -lplugin main.f xxx.f
#===== 3. 执行 ============
install_name_tool -add_rpath /opt/anaconda2/envs/py37/lib ./main ! for macos  
./main 
``` 


###### 参考

[Call python from Fortran](https://github.com/nbren12/call_py_fort.git) 

[cffi documents](https://cffi.readthedocs.io/en/latest/embedding.html)
