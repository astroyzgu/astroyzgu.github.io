## multiprocessing多进程  

计算需要有一定的强度才能体现出多进程的优势!!!

| 备注   | 执行        | 对于计算量有一定的强度的多进程，拆分任务会更好 |
|--------|-------------|----------------------------|
| [推荐] | apply_async | 4.02s for  12500 times per core |
|[默认没有返回] | Process | 和apply_async类似 | 
|        | map_async   |       4.40s for 100000 times with 8 cores | 
|        | for循环     |    20.51s for 100000 times |

###### 用于多进程IO或计算的code 

``` python 
import multiprocessing as mp 
import time 
import numpy as np 
import math

def f(x):
    ''' 
    计算需要有一定的强度才能体现出多进程的优势
    '''
    for ii in range(1000): summ =  math.log(1+ii+x)
    return x*x

def f_split(x):  
    return [f(x_) for x_ in x]

if __name__ == '__main__':
    size    = 8 
    ngal    = 100000
    arr     = np.arange(ngal)
    arr_split = np.array_split( arr,  size) 

    t_start = time.time()    
    '''
    设置了4个CPU但是并没有跑满 
    result  = pool.map_async(f, arr)  

    因为Pool 只是用来启动多个进程而不是在每个core上启动一个进程。
    换句话说Python解释器本身不会去在每个core或者processor去做负载均衡。
    自己做负载均衡(拆分任务), 一定程度上缓解了这个问题。
    但是，计算需要有一定的强度才能体现出多进程的优势(因为启动多进程也需要时间)。  
    '''
    method = 3
    if method == 1: 
       pool    = mp.Pool(processes=size)           
       res = []
       for ii in range(size):  
           r = pool.apply_async( f_split, args = (arr_split[ii],),  ) 
           res.append(r)
       pool.close() 
       pool.join() 
       res = np.hstack([r.get() for r in res])
       print( res.shape, res[:10] )
    if method == 2: 
       pool    = mp.Pool(processes=size)           
       res  = pool.map_async(f, arr)  
       pool.close() 
       pool.join() 
       res = np.hstack(res.get())
       print( res.shape, res[:10] )
    if method == 3: 
       jobs = []
       # 没有return, 需要额外的共享内存变量  
       for ii in range(size):  
           job = mp.Process(target = f_split, args = (arr_split[ii],), )  
           jobs.append(job)
       for job in jobs: job.start()
       for job in jobs: job.join() 

    t_stop  = time.time() 
    print("程序总耗时%0.2fs:"%(t_stop-t_start))
    t_start = time.time()    
    res = np.array( [f(ii) for ii in arr] )
    print( res.shape )
    t_stop  = time.time()
    print("程序总耗时%0.2fs:"%(t_stop-t_start))
``` 


###### 共享内存的计算

| 备注   | 执行        | mp.Array和mp.value共享内存 |
|--------|-------------|----------------------------|
|[推荐] | Process     | 但是没有默认的return | 
|[无效] | apply_async | |
|[无效] | map_async   | | 
|       | for循环     | |

mp.Pool会复制已有变量，多进程会造成内存溢出。

- 在各进程需要共用很大的数据时，可用mp.Array共享内存,或操作（只对Process类有效）。 

- 在各进程仅需要读取数据最后合并时，用apply_async有返回值会比较方便。 

``` python 
import multiprocessing as mp 
import ctypes 
import numpy as np
import time


def mp2np(mp_array, shape = None):
    '''Given a multiprocessing.Array, returns an ndarray pointing to
    the same data.'''
    # support SynchronizedArray:
    _ctypes_to_numpy = {
    ctypes.c_char   : np.dtype(np.uint8),
    ctypes.c_wchar  : np.dtype(np.int16),
    ctypes.c_byte   : np.dtype(np.int8),
    ctypes.c_ubyte  : np.dtype(np.uint8),
    ctypes.c_short  : np.dtype(np.int16),
    ctypes.c_ushort : np.dtype(np.uint16),
    ctypes.c_int    : np.dtype(np.int32),
    ctypes.c_uint   : np.dtype(np.uint32),
    ctypes.c_long   : np.dtype(np.int64),
    ctypes.c_ulong  : np.dtype(np.uint64),
    ctypes.c_float  : np.dtype(np.float32),
    ctypes.c_double : np.dtype(np.float64)}
    if not hasattr(mp_array, '_type_'):
        mp_array = mp_array.get_obj()
    dtype = _ctypes_to_numpy[mp_array._type_]
    result = np.frombuffer(mp_array, dtype)
    if shape is not None:
        result = result.reshape(shape)
    return np.asarray(result)

def np2mp(np_array, lock = False):
    '''Generate an 1D multiprocessing.Array containing the data from
    the passed ndarray.  The data will be *copied* into shared
    memory.'''
    _ctypes_to_numpy = {
    ctypes.c_char   : np.dtype(np.uint8),
    ctypes.c_wchar  : np.dtype(np.int16),
    ctypes.c_byte   : np.dtype(np.int8),
    ctypes.c_ubyte  : np.dtype(np.uint8),
    ctypes.c_short  : np.dtype(np.int16),
    ctypes.c_ushort : np.dtype(np.uint16),
    ctypes.c_int    : np.dtype(np.int32),
    ctypes.c_uint   : np.dtype(np.uint32),
    ctypes.c_long   : np.dtype(np.int64),
    ctypes.c_ulong  : np.dtype(np.uint64),
    ctypes.c_float  : np.dtype(np.float32),
    ctypes.c_double : np.dtype(np.float64)}
    _numpy_to_ctypes = dict(zip(_ctypes_to_numpy.values(), _ctypes_to_numpy.keys()))
    array1d = np_array.ravel(order = 'A')
    try:
        c_type = _numpy_to_ctypes[array1d.dtype]
    except KeyError:
        c_type = _numpy_to_ctypes[np.dtype(array1d.dtype)]
    mp_array   = mp.Array( c_type, array1d.size, lock = lock)
    mp2np(mp_array)[:] = array1d
    return mp_array



def sharemem_demo(ngal  = 1000):  
#------ 共享1维数组------
    np_arr1d = np.arange(ngal)
    mp_arr1d = np2mp(np_arr1d); 
    np_arr1d = mp2np(mp_arr1d, np_arr1d.shape)

#------ 共享2维数组------

    np_arr2d = np.random.normal(0, 1, (ngal, 3) )

    # 用ctypes类型存储数组 
    mp_arr2d = np2mp(np_arr2d); 
    np_arr2d = mp2np(mp_arr2d, np_arr2d.shape)
 
    # np_arr2d[x,y]= mp_arr2d[y+2*x]
    # x = 2; y = 1
    # print(mp_arr2d[2*x+y], np_arr2d[x, y]) 

    # mp_arr2d和np_arr2d共享内存，改变一边，另一边随之改变
    np_arr2d[0, 0] = 1; mp_arr2d[1] = 2 

    # print(np_arr2d[0,:], np_arr2d[1,:], np_arr2d[2,:])     
    # print(mp_arr2d[:6])   
    return np_arr1d, np_arr2d, mp_arr1d, mp_arr2d

def worker(x, y):
    return x+y 

def worker_split1(task_split, mp_arr2d, shape) :  
    np_arr2d = mp2np(mp_arr2d, shape) 
    np_arr2d[task_split, 2] = np.hstack([worker( np_arr2d[ii,0], np_arr2d[ii,1] ) for ii in task_split])
    return np_arr2d[task_split, 2]

def worker_split2(task_split, np_arr2d) :  
    np_arr2d[task_split, 2] = np.hstack([worker( np_arr2d[ii,0], np_arr2d[ii,1] ) for ii in task_split])
    return np_arr2d[task_split, 2]

if __name__ == '__main__':  
    ngal = 100000; size = 4 
    np_arr1d, np_arr2d, mp_arr1d, mp_arr2d = sharemem_demo(ngal  = ngal)
    np_arr2d[0, 0] = 2; mp_arr2d[1] = 1
    print(np_arr2d[0,:], np_arr2d[1,:], np_arr2d[2,:])     
    print(mp_arr2d[:6]) 


    print( '#------ run --------' )

    array_split = np.array_split( np.arange(ngal), size )
    method = 1
    if method == 1: 
        start = time.time();     
        pool = mp.Pool(size)
        res = [] 
        for ii in range(size): 
            r  = pool.apply_async(worker_split2,  args = (array_split[ii], np_arr2d) ) 
            res.append(r)
        pool.close()
        pool.join()  
        end = time.time(); t = end-start 
        print( np.hstack( [r.get() for r in res] )[:5] )
        #print( np_arr2d[:5, 2] )
        print("multiprocess takes %s s"% t ) 
    if method == 2: 
        start = time.time();     
        jobs = []
        for ii in range(size): 
           job = mp.Process(target=worker_split1, args=(array_split[ii], mp_arr2d, np_arr2d.shape))
           jobs.append( job ) 
        for job in jobs: job.start()
        for job in jobs: job.join()
        end = time.time(); t = end-start 
        print( np_arr2d[:5, 2] )
        print("multiprocess takes %s s"% t ) 

    start = time.time(); 
    res = np.hstack([worker(np_arr2d[ii,0], np_arr2d[ii,1]) for ii in range(ngal) ])
    print(np_arr2d[:5,0])
    print(np_arr2d[:5,1])
    print(res[:5])
    end = time.time(); t = end-start
    print(" 'for' loops takes %s s"% t ) 
``` 

