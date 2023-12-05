# python调用c语言 

[Python调用C/Fortran混合的动态链接库](https://blog.csdn.net/weixin_30488085/article/details/98787832)

[在python里调用C函数的三种方式](https://blog.csdn.net/tianya_lu/article/details/124828175)


#### c extension

```
"""====================1.原始c程序========================="""
#include <stdio.h>
int add(int a, int b)
{
    return a + b;
}
 
int main()
{
    int a=1,b=1;
    printf("%d\n", add(a,b));
}
"""====================2.python的扩展模块========================="""
"""== Python.h, C函数, python代码调用的接口函数，初始化函数 ======"""
// pulls in the Python API 
#include <Python.h>
 
// C function always has two arguments, conventionally named self and args
// The args argument will be a pointer to a Python tuple object containing the arguments.
// Each item of the tuple corresponds to an argument in the call’s argument list.
static PyObject *
demo_add(PyObject *self, PyObject *args)
{
    const int a, b;
    // convert PyObject to C values
    if (!PyArg_ParseTuple(args, "ii", &a, &b))
        return NULL;
    return Py_BuildValue("i", a+b);
}
 
// module's method table
static PyMethodDef DemoMethods[] = {
    {"add", demo_add, METH_VARARGS, "Add two integers"},
    {NULL, NULL, 0, NULL} 
};
 
// module’s initialization function
PyMODINIT_FUNC
initdemo(void)
{
    (void)Py_InitModule("demo", DemoMethods);
}


"""=====3. setup.py文件=====" 
from distutils.core import setup, Extension
 
module1 = Extension('demo',
                    sources = ['demomodule.c']
                    )
setup (name = 'a demo extension module',
       version = '1.0',
       description = 'This is a demo package',
       ext_modules = [module1]) 
"""=====4. 利用distutils或setuptools完成gcc编译和链接=====" 
python setup.py build_ext --inplace 
# 当前目录生成一个demo.so(python扩展模块)。
# 是一个共享库(.so)，可以直接在python解释器中import。
# --inplace表示将生成的扩展放到源码所在的目录
"""=====5. test.py====="""
from demo import add
print(add(1,1) )
"""=====6.  执行 ====="""
python test.py  
```

备注: python2下有效， python3下扩展模块的写法需要改动

#### Cython

```
"""====================1.hello.py程序========================="""
#cython: language_level=3

import time 
t0 = time.time()
sum = 0
for ii in range(10000000): sum = sum + ii 
t1 = time.time()
print("Hello World! sum is %s"% sum)
print("Loop 10000000 times Using %s s"% (t1 -t0) )
"""====================2.cython编译========================="""
# @macos 
cython --embed -o hello.c hello.py 
gcc -Os  -o hello hello.c -lpython3.7m -lm -I /opt/anaconda2/envs/py37/include/python3.7m/ -L /opt/anaconda2/envs/py37/lib/
export LD_LIBRARY_PATH=/opt/anaconda2/envs/py37/lib/:$LD_LIBRARY_PATH 
./hello 
"""====================3.执行程序========================="""
python hello.py # 直接执行～0.78 s
./hello         # cpython编译后执行～0.83 s
```

没有直接用cython语句写的pyx文件作为例子 

#### ctypes

``` c
"""====================1.c程序========================="""
    #include <stdio.h> 
    int add(int a, int b)
    {
        return a + b;
    }
 
    int main()
    {
    int a=1,b=1;
    printf("%d\n", add(a,b));
    } 
"""===============2.编译c程序，生成动态链接库========================="""
gcc -shared -o libadd.so libadd.c # 编译成动态链接库 
# BTW：执行gcc libadd.c; a.out, 也可以直接运行c 
"""=============3.通过ctyps和numpy完成在python中调用============"""
from ctypes import * 
myclib = CDLL('libadd.so')
add = myclib.add
print( add(1,1) )

```


## 使用setuptools工具

```python  
from Cython.Build import cythonize
from codecs import open
from os import path

ext_for = Extension(name='src.f1',
                  sources=['src/f1.f'] )
ext_cpp = Extension(name='src.hello',
                  sources=['src/hello.cpp'],
                  language='c++' )


here = path.abspath(path.dirname(__file__))

# Get the long description from the README file
with open(path.join(here, 'README.rst'), encoding='utf-8') as f:
    long_description = f.read()

setup(
    name='csstmock', # 包名
    version='0.0.0', # 版本号
    description='Construct mock and mask for CSST. ', # 描述
    long_description=long_description, # 长段描述，即README.rst 
    url='',          # 项目主页   
    author='SJTU group', # 作者名
    author_email='guyizhou@sjtu.edu.cn', # 作者邮箱
    classifiers=[ # 分类
        'Development Status :: 4 - Beta',
        'Intended Audience :: Science/Research',
        "License :: OSI Approved :: GNU General Public License v2 or later (GPLv2+)",
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Fortran',
        'Programming Language :: C++',
        'Topic :: Scientific/Engineering :: Astronomy',
        "Topic :: Scientific/Engineering :: Visualization",
    ],
    keywords='CSST, mock, mask',
    packages= find_namespace_packages('csstmock'),
    # find_packages()自动搜寻，但是只会打包内含__init__.py的包。
    # find_namespace_packages()没有这个限制,  若想指定文件夹，可以在后面加参数。
    # packages=find_namespace_packages('src') 
    ext_modules = [ext_cpp],
    include_package_data=True,
    install_requires=[ 'astropy>=5.0'], # 自动安装依赖 
    license="GPLv2",  # 协议
    python_requires='>=3.7', # 限制python版本
)
```
