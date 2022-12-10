tricks 
==========

:doc:`quickplot_plot2d` Histogram2d & Kernel smoothed normalized density
:doc: KS, AD, perm test [ permutation(perm), Anderson–Darling (AD) ]

sudo pkill -f fsck 

try except语句
^^^^^^^^^^^^^^^

.. code-block:: python

    try:
        f = open('该文档不存在')
        print(f.read())
        f.close()
    except OSError as reason:
        print('文件出错了T_T')

利用healpy判断有无数据在某区域中
^^^^^^^^^^^^^^^

.. code-block:: python 

    import astropy
    import healpy as hp
    import numpy 
    # 利用healpy判断是否有数据在某个区域中（区域必须是凸多边形）
    ra_box_  = [] 
    dec_box_ = []  
    xyzpoly  = astropy.coordinates.spherical_to_cartesian(1, dec_box_/180*np.pi, ra_box_/180*np.pi ) # r, lat, lon -> x, y, z
    xyzpoly  = np.array(xyzpoly).T; 
    qp       = hp.query_polygon(nside, xyzpoly[::-1], nest = True, inclusive = True) 
    if np.sum( np.isin(qp, ipixs) ) > 0:   
        ... # 有数据在这个区域中
        
    else:
        ... # 没有数据在这个区域中


内存监控
^^^^^^^^^^^^^^

| **memory-profiler** 

.. code-block:: python 

   #pip install memory_profiler
   #pip install psutil 

   #memory_profiler是用来分析每行代码的内存使用情况. 
   #使用方法一：. 
   #from memory_profiler import profile
   #在函数前添加@profile.  @profile

   mprof run --multiprocess multi_processing_example.py
   mprof plot

| https://coderzcolumn.com/tutorials/python/how-to-profile-memory-usage-in-python-using-memory-profiler

| **pustil**
| https://psutil.readthedocs.io/en/latest/#functions

.. code-block:: python 

    import psutil
    import os 
    import numpy as np 
    
    def pid_info(pid = None): 
        if pid is None:  pid     = os.getpid()
        p       = psutil.Process( pid )
        memcost = p.memory_info().rss/1024**2
        threads = p.num_threads()
        cpucost = p.cpu_percent()
        print('Process %s cost ~ %.2f Mb, %.2f '%(pid, memcost, cpucost) + 'cpu%', 'running in %s threads'%threads)
    
    large_data = np.random.uniform(0, 1, size = (10000000, 4) )
    pid_info() # Process 43491 cost ~ 340.68 Mb, 0.00 cpu% running in 1 threads
    del large_data
    pid_info() # Process 43491 cost ~ 35.53 Mb, 0.00 cpu% running in 1 threads

functools.partial
^^^^^^^^^^^^^^
.. code-block :: python

    from functools import partial 
    def user_func(x, y, z = 1): 
        return x+y+z
    print( user_func(1,1) )
    # 返回： 3
    
    # 1. 固定参数
    new_func = partial(user_func, z = 2) #将user_func中的z参数固定为2
    print( new_func(1,1) ) # 在调用新生成的函数new_func时，不能在传入参数z了
    # 返回： 4
    
    # 2. 回调函数 
    def show(name, age): 
        print('My name is %s and age is %s'%(name, age))
    
    def test(callback): 
        print("do some opt...") 
        callback()
    # 如果回调函数无法预知参数，且不知道会如何调用，可以这样子生成新的函数
    showP = partial(show, 'Yizhou', 18) 
    test(showP)

notebook display gif
^^^^^^^^^^^^

.. image :: images/running.gif.png

.. code-block :: python

    import imageio 
    import shutil 
    import os 
    from IPython import display
    import numpy as np 
    
    writer      = imageio.get_writer("running.gif",mode="I")
    for ii in range(0,100): 
        fig, ax = plt.subplots()
        gauss = np.random.normal(ii, 2, 1000 ) 
        ax.hist(gauss, bins = 100)
        ax.text(0.9, 0.9, "run %s"%ii, transform = ax.transAxes)
        ax.set_xlim(-3,103)
        ax.set_ylim( 0, 40)
        plt.savefig("frame.png".format(ii) )
        plt.close()
        writer.append_data(imageio.imread("frame.png".format(ii)))
        os.remove("frame.png") 
    writer.close()
    shutil.copy2("running.gif","running.gif.png")
    display.Image(filename="running.gif.png")

jupyter notebook
^^^^^^^^^^^^
- 添加名为py37的环境到notebook中
   - ``python -m ipykernel install --user --name py37 --display-name "py37"``


bash 
^^^^^^^^^^^^
- 一级目录文件的大小
   - ``du -h --max-depth=1 ./ # linux``
   - ``du -h -d 1 ./   # macos``

numpy remove nan & inf
^^^^^^^^^^^^

.. code-block :: python

   import numpy as np 
   arr  = np.array([1, np.nan, -1, np.inf, 2, -np.inf])
   print( arr[~np.isnan(arr)&~np.isinf(arr) ]) # 去除nan, inf
   # [ 1. -1.  2.]

numpy unique
^^^^^^^^^^^^

.. code-block :: python
 
   # unique的用法
   # https://numpy.org/doc/stable/reference/generated/numpy.unique.html
   import numpy as np
   a = np.array([3,2,1,3,1,1,1,4])
   uniq, index, inverse, counts = np.unique( a,  return_index=True, return_inverse = True, return_counts = True )
   print(a, '# 输入表格') 
   print(uniq, '# 返回的唯一值') 
   print(index, a[index], '# 返回的唯一值，在输入表格中第一次出现的位置')
   print(inverse, '# 返回的唯一值，在输入表格中的位置 ' )
   print(counts, '# 返回的唯一值，对应的计数')
   print(uniq[inverse],'# 还原输入表格') 
   print(counts[inverse], '# 生成与输入表格对应的计数')

.. code-block :: python

    # one-hot 
    import numpy as np
    a = ['0', '1', '6', '1'] 
    b = ['0', '1', '6', '4', '1'] 
    a = np.atleast_1d(a); b = np.atleast_1d(b)  
    uniq_b, inverse_b = np.unique( b, return_inverse = True)
    uniq_a, inverse_a = np.unique( a, return_inverse = True)
    num_classes   = len(uniq_b) # 以数据b作为参考编码
    coding        = np.arange( num_classes) 
    one_hot_codes = np.eye( num_classes) 
    indx_ab = np.isin(uniq_a, uniq_b)
    if np.sum(~indx_ab)!= 0: # 如果a中的元素在b中没有， 则需要报错或停止 
        print('Elemennts (e.g., %s) not in the list  '% a[~indx][0])  
    print('#------------------------------------------')    
    print('以数组b中唯一的元素编码', uniq_b, '-->', coding )
    
    one_hot_codes = np.eye(num_classes)
    for ii in coding: 
        print(ii, uniq_b[ii], one_hot_codes[ii,:]) 
    print('#------------------------------------------')    
    print('用这组编码 对新的数组a进行编辑 ')
    print('以数组a中唯一的元素为', uniq_a ) 
    indx_ba = np.isin(uniq_b, uniq_a) # 找到对应关系
    print('找到对应关系', uniq_a, '-->',  coding[indx_ba] ) 
    print( uniq_a[inverse_a], '-->', coding[indx_ba][inverse_a] ) 
    print( one_hot_codes[ coding[indx_ba][inverse_a] ] )
    
    for ii in coding[indx_ba][inverse_a]: 
        print(ii, uniq_b[ii], one_hot_codes[ii,:])  
    print('#------------------------------------------') 

    >>> #------------------------------------------
    >>> 以数组b中唯一的元素编码 ['0' '1' '4' '6'] --> [0 1 2 3]
    >>> 0 0 [1. 0. 0. 0.]
    >>> 1 1 [0. 1. 0. 0.]
    >>> 2 4 [0. 0. 1. 0.]
    >>> 3 6 [0. 0. 0. 1.]
    >>> #------------------------------------------
    >>> 用这组编码 对新的数组a进行编辑 
    >>> 以数组a中唯一的元素为 ['0' '1' '6']
    >>> 找到对应关系 ['0' '1' '6'] --> [0 1 3]
    >>> ['0' '1' '6' '1'] --> [0 1 3 1]
    >>> [[1. 0. 0. 0.]
    >>>  [0. 1. 0. 0.]
    >>>  [0. 0. 0. 1.]
    >>>  [0. 1. 0. 0.]]
    >>> #------------------------------------------
    >>> 0 0 [1. 0. 0. 0.]
    >>> 1 1 [0. 1. 0. 0.]
    >>> 3 6 [0. 0. 0. 1.]
    >>> 1 1 [0. 1. 0. 0.]
    >>> #------------------------------------------


numpy split 
^^^^^^^^^^^^^^^^^^

.. code-block :: python

    aaa = np.array([1,2,3,4,5,6,7,8])
    bbb = np.cumsum([2, 3, 2, 2]) # 总数对不上也可以
    print( bbb )
    print( np.split(aaa, bbb) ) 
    #>>> [2 5 7 9]
    #>>> [array([1, 2]), array([3, 4, 5]), array([6, 7]), array([8]), array([], dtype=int64)]

astropy table (write, rename_columns)
^^^^^^^^^^^^^^^^^^^^

.. code-block :: python

    import numpy as np 
    from astropy.table import Table, vstack, hstack 
    t1 = Table(); t1['col1'] = np.random.uniform(0,1,2)  
    t2 = Table(); t2['col1'] = np.random.uniform(0,1,2)  
    t_left  = vstack([t1, t2]) 
    t1 = Table(); t1['col2'] = np.random.normal(0,1,2)  
    t2 = Table(); t2['col2'] = np.random.normal(0,1,2)  
    t_right = vstack([t1, t2]) 
    t = hstack([t_left, t_right])
    print(t.colnames)
    t.rename_columns(t.colnames, ['1', '2'])
    print(t)
    t.remove_row(1)
    print(t)

    # data = Table.from_pandas(df)
    t.write('output.csv', format = 'ascii.fixed_width', delimiter = None,  overwrite=True)
    t.write('output.fits', overwrite=True)

astropy cosmology 
^^^^^^^^^^^^^^^^^^^^

