### python astro  

<details><summary><b> work with Table from astropy  </b> </summary>
<p>

``` python  
# 数据的储存 
import numpy as np
from astropy.table import Table

np.random.seed(0)
num = 1000
id    = np.arange(1, num + 1)
ipix  = np.random.randint(0, 2000, size = num)
x     = np.random.uniform(-50, 50, size = num)
y     = np.random.uniform(-50, 50, size = num)
tab = Table() 
tab['id']   = id 
tab['ipix'] = ipix
tab['x']    = x
tab['y']    = y
tab['new-id'] = np.char.array( tab['id'] , unicode = 'utf8') + '_' + np.char.array( tab['ipix'] , unicode = 'utf8')
#print(tab)
# 构建1E7量级的数据
#              id  ipix          x          y
#               1   684 -32.564448  -4.125729
#               2   559 -10.851334   2.854080
#               3  1653  21.721634  47.349101
#             ...   ...        ...        ...              
ipixs, unique_indices, unique_inverse, unique_counts = np.unique(ipix, return_counts =True, return_index=True, return_inverse =True)
tab.write('mock_data.fits', overwrite = True)
tab.write('mock_data.csv', format = 'ascii.fixed_width', delimiter = None,  overwrite=True)
```

</p>
</details>

<details><summary><b> read & scatter  </b> </summary>
<p>

``` python 
from astropy.table import Table 
from astropy.io import ascii 
tab = ascii.read('/Users/njnu-astro/Desktop/mock_data.csv')
tab = Table.read('/Users/njnu-astro/Desktop/mock_data.fits')
print(tab.columns)

import matplotlib.pyplot as plt
fig, axs = plt.subplots(1,2, figsize = (8, 4))
fig.subplots_adjust(top = 0.98, wspace = 0.3) 
ax = axs[0]
bins = [-50, -20, 0, 30, 50]; bins = 100
bins = np.linspace(-50, 50, 101); # 推荐
ax.hist(x, bins = bins, density = True, histtype = 'step', color = 'k', hatch = '//////', alpha = 0.5, label = 'x distribution')
ax.text(-40, 0.0025, 'aaa', color = 'r', fontsize = 14)
ax.text(0.1, 0.9, 'bbb', transform = ax.transAxes, color = 'b', fontsize = 14)
ax.legend() 
ax.set_xlim(-50, 50)
ax.set_xlabel('x'); ax.set_ylabel('#')

ax = axs[1]
indx = tab['ipix'] <  500; x_ = x[indx]; y_ = y[indx]
ax.scatter(x_, y_, color = 'b', s = 1, marker= '.', label = 'ipix < 500') 

indx = tab['ipix'] >= 500; x_ = x[indx]; y_ = y[indx]
ax.scatter(x_, y_, color = 'r', s = 1, marker= '.', label = 'ipix > 500') 
ax.legend() 
ax.set_xlim(-50, 50); ax.set_ylim(-50, 50)
ax.set_xlabel('x'); ax.set_ylabel('y')
plt.savefig('example.png', bbox_inches = 'tight', dpi=300)
plt.show() 
``` 

</p>
</details>


<details><summary><b> plot  </b> </summary>
<p>

``` python 
import matplotlib.pyplot as plt
import numpy as np

poly1   = np.array([ 8.5*15, -2,   8.5*15,  5,   15*15,   5,  15*15, -2,  8.5*15, -2])
poly2   = np.array([-2.0*15, -1,  -2.0*15,  7, 2.67*15,  7, 2.67*15, -1, -2.0*15, -1])
poly3   = np.array([1.83*15, -7,  1.83*15, -1, 2.67*15, -1, 2.67*15, -7, 1.83*15, -7])

fig, ax = plt.subplots()
ax.plot(poly1[0::2], poly1[1::2], label = '~ 680 deg2')
ax.plot(poly2[0::2], poly2[1::2], label = '~ 560 deg2')
ax.plot(poly3[0::2], poly3[1::2], label = '~ 75 deg2')
ax.set_title('PFS Cosmology region')
ax.set_xlabel('ra')
ax.set_ylabel('dec')
plt.show() 
``` 

</p>
</details>



