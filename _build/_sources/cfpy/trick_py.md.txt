# os.system 

``` python
import subprocess
r = subprocess.run('pwd', shell=True, capture_output=True) 

import os 
os.system('pwd  > /dev/null ')
```

# numpy tricks

###### 两个一维数据计算，产生二维数组

``` python 
a = np.array([1,2,3])
b = np.array([1,2])
c = a.reshape(-1, 1) - b
print(c.shape) # (3, 2)
print(c) 
#[[ 0 -1]
# [ 1  0]
# [ 2  1]]
print(c.argmin(axis = 0))
# [0 0]
```

