asfunc interface 
------------------


简介
''''''''''''''''''

提供三个函数：

1. assignwht1d/assignwht2d  数值计算+返回权重给w并写入文件results.csv中

| USAGE: assignwht  [权重文件]  [输入文件] [数据开始行]
| assignwht1d  [权重文件] 1维权重，仅为位置的函数，格式为# ipix_256 wht
|              [输入文件] 格式为# ra dec
| assignwht2d  [权重文件] 2维权重，除位置之外，还为是第二个参数的函数，如zmag
|                         格式为# ipix_256 w_0.00_to_16.00 ...
|              [输入文件] 格式为# ra dec zmag [或其他]

2. mollview [输入文件] [nside = 128]

| USAGE: mollview   [输入文件] [数据开始行]
|        输入ra和dec，保持计数图像（默认nside = 128)

配置
''''''''''''''''''

python3.7环境配置
""""""""""""""""""

| 创建一个新的环境： ``conda create -n py3-test python=3.7``
|                    py3-test为新环境的名称
| 激活这个新的环境： ``conda activate py3-test``
| 若要退出这个环境： ``conda deactivate``
| 为这个环境安装相关的包：

.. code-block :: 

   conda install matplotlib
   conda install basemap
   conda install cffi
   conda install tqdm
   pip install healpy
   pip install pymangle

由于最新的matplotlib3.4没有这个dedent包，与basemap插件调用方式不一致，需要调整一下basemap的源码（下面这两个文件）：

- ``/home/yzgu/.conda/envs/py3-test/lib/python3.7/site-packages/mpl_toolkits/basemap/__init__.py``
- ``/home/yzgu/.conda/envs/py3-test/lib/python3.7/site-packages/mpl_toolkits/basemap/__init__.py``

将这两个文件中的``from matplotlib.cbook import dedent``替换为``from inspect import cleandoc as dedent`` 


在Gravity上运行
""""""""""""""""""

.. code-block :: 

    python builder.py # 生成库文件libplugin.so(linux)和libplugin.dylib(Macos)
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$pwd # 将当前目录添加到库文件的搜索路径
    export PYTHONPATH=$PYTHONPATH:$pwd # 将当前目录添加到PYTHON库文件的搜索路径
    gfortran -o ./assignwht -L./ -lplugin assignwht.f
    gfortran -o ./mollview  -L./ -lplugin mollview.f
    

在macos上运行
""""""""""""""""""

.. code-block :: 

   python builder.py # 生成库文件libplugin.so(linux)和libplugin.dylib(Macos)
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$pwd # 将当前目录添加到库文件的搜索路径
   export PYTHONPATH=$PYTHONPATH:$pwd # 将当前目录添加到PYTHON库文件的搜索路径
   gfortran -o ./assignwht -L./ -lplugin assignwht.f
   gfortran -o ./mollview  -L./ -lplugin mollview.f


细节
''''''''''''''''''

传递Fortran数组给Python
""""""""""""""""""

The reference of the communication of Fortran/C and python: 

- https://www.noahbrenowitz.com/post/calling-fortran-from-python/
- https://cloud.tencent.com/developer/article/1618235
- http://www.yolinux.com/TUTORIALS/LinuxTutorialMixingFortranAndC.html

healpy画图
""""""""""""""""""

.. code-block:: python 

    from astropy.table import Table
    from astropy.io import ascii
    import numpy as np 
    import healpy as hp
    import matplotlib.pyplot as plt
    # ID RA DEC redshift 
    num = 100000; nside = 128
    tab = Table()
    tab['ID']       = np.arange(1, num + 1)
    tab['RA']       = np.random.uniform(140, 160, num)
    tab['DEC']      = np.random.uniform( -5,   5, num)
    tab['redshift'] = np.random.uniform( 0.1,   0.3, num)
    tab['ipix']     = hp.ang2pix(nside, tab['RA'], tab['DEC'], nest = True, lonlat=True)
    idx, counts = np.unique(tab['ipix'], return_counts = True) 
    zmap = np.zeros( 12*nside*nside ) + np.nan 
    zmap[idx] = counts
    hp.cartview( zmap, nest = True, lonra=[139, 161], latra = [-5.5, 5.5])
    plt.show()

