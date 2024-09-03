# numpy大数据处理

###### 数组堆叠

- 推荐使用append + vstack 

- 效率最高是预申请一个empty数组


``` python 
import numpy as np 
import time 

# append添加是将容器看作整体来进行添加
# extend是将容器打碎后添加（加入的只是元素）

lst1 = []; lst2 = []
data_split = [np.array([0,1,2]), np.array([3,4]) ]
data_split = [np.array([[0,1,2], [3,4,5]]), np.array([[3,4,5], [5,6,7]]) ]
for ii in range(2): lst1.append(data_split[ii]) 
for ii in range(2): lst2.extend(data_split[ii]) 
print('lst1 by append (作为2份整体):', lst1)
print('lst2 by extend (打碎成了5份):', lst2)
print('extend:', np.vstack(lst2).shape )
print('append:', np.vstack(lst1).shape )
print('--------------------------------')

# 直接申请一个大的矩阵 (~2s)
data = np.random.normal( 0, 1, size = (455113000, 1) ).astype('float64')
data_split = np.array_split(data, 72)

t1 = time.time()
ngal_max = 2147483647
data = np.empty((ngal_max, 1) , dtype = 'float64')
ngal = 0
for data_split_ in data_split:
    ngal_, dim = data_split_.shape 
    data[ngal:ngal+ngal_,:] = data_split_
    ngal = ngal + ngal_
t2 = time.time()
data = data[:ngal]
print(ngal)
print(data.shape, 'Using empty takes %s'%(t2- t1) ) 
del data 

# extend + vstack 很耗时间(~105s, vstack耗时15s)
data_lst = []
t1 = time.time()
for data_split_ in data_split:
    data_lst.extend(data_split_) 
t2 = time.time()
print('loop takes %s'%(t2- t1) ) 
data = np.vstack(data_lst)
t2 = time.time()
print(data.shape, 'Using extend takes %s'%(t2- t1) ) 
del data
del data_lst

# append + vstack 挺快的 (~2s，主要在vstack上耗时)
t1 = time.time()
data_lst = []
for data_split_ in data_split:
    data_lst.append(data_split_) 
t2 = time.time()
print('loop takes %s'%(t2- t1) ) 
data = np.vstack(data_split)
t2 = time.time()
print(data.shape, 'Using append takes %s'%(t2- t1) ) 
del data
del data_lst
```  

