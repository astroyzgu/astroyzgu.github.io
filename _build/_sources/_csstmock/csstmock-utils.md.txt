# csstmock.utils

## mockimg 

<details><summary><b>  mockimg </b> </summary>
<p>

``` 
import numpy as np 
import csstmock.utils as utils 

a1 = [231.084306605587, 231.08615163187181, 231.0990037678654, 231.1006504047034]
d1 = [29.9092334907227, 29.905939898436632, 29.91424346706406, 29.89506662846340]
imgs = []
for band in ['z','r','g',]: 
    mimg      = utils.mockimg(outputdir = './output-mockimg/', survey = 'desidr9', band = band) 
    fitsnames = mimg.downloads(a1, d1, size = [100, 100], suffix = 'fits') 
    stamps    = mimg.readimgs(fitsnames)
    #print(np.shape(stamps)) 
    autowcs   = mimg.autowcs(  a1, d1) 
    img, msk, hdr  = mimg.run(a1, d1, stamps, autowcs,)
    mimg.save(img,  hdr, msk = msk) 
mockimg = mimg.rgb(['z','r','g',])

#--- real images 
size = autowcs.pixel_shape
a0   = autowcs.wcs.crval[0]
d0   = autowcs.wcs.crval[1]
print(a0, d0, size)
mimg      = utils.mockimg(outputdir = './output-mockimg/', survey = 'desidr9', band = 'z') 
fitsnames = mimg.downloads([a0], [d0], suffix = 'fits', size = size)
realimg, header   = mimg.readimgs(fitsnames, return_headers = True)
from astropy.wcs import WCS
wcs2d  = WCS(header)
xc, yc = wcs2d.wcs_world2pix(a1, d1, 0) 

mimg      = utils.mockimg(outputdir = './output-mockimg/', survey = 'desidr9', band = 'grz') 
fitsnames = mimg.downloads([a0], [d0], suffix = 'jpeg', size = size)
realimg, header   = mimg.readimgs(fitsnames, return_headers = True)
realimg = realimg[0]

import matplotlib.pyplot as plt
fig, axs = plt.subplots(1,2 , figsize = (12, 5))
axs[0].imshow(realimg[::-1], ); axs[0].set_title('reak image')
axs[0].scatter(xc, yc, edgecolor = 'r', facecolor = 'none', s = 300) 
axs[1].scatter(xc, yc, edgecolor = 'r', facecolor = 'none', s = 300) 
axs[1].imshow(mockimg); axs[1].set_title('mock image')
for ax in axs: 
    pixel  = 0.5/60/(0.262/3600) # pixscale = 0.262/3600 # deg/pixel
    size   = np.shape(mockimg) 
    ix = size[0]*0.55;  iy = size[1]*0.90
    ax.plot([ix, ix+pixel], [iy, iy], color = 'g') 
    ax.text( ix +0.5*pixel, iy, '0.5 arcmin', color = 'g', ha = 'center', va = 'bottom')
    ax.axis('off'); 

plt.show() 

``` 

</p>
</details>
 

## lftools for (conditional) luminosity function 

<details><summary><b> luminosity function </b> </summary>
<p>

``` 
import numpy as np 
import matplotlib.pyplot as plt 
from csstmock.utils import lftools
lf = lftools(H0 = 67.4, Om0 = 0.315) # initializing cosmology 
# data = np.vstack([igal, a, d, zgal, mag, kcorr, compl, igrp, imem, zgrp, mgrp]).T 
data= np.load('./dat/desidr9v2/DESIDR9v2_sv3_zband21_for_CLF.npy') 
zgal   = data[:,3] # np.array([0.01, 0.05, 0.1, 0.3,  1.0])
mapp   = data[:,4] # np.array([21, 21, 21.,  21,    21, ])

kcorr_func = np.poly1d([0.73, -0.54, -0.33])  
kcorr  = data[:,5] # kcorr_func(zgal)

#
# calculate luminosity and zmax 
#
loglum = lf.app2abs(zgal, mapp, kcorr = kcorr, Msun = 4.83)
magabs = lf.app2abs(zgal, mapp, kcorr = kcorr ) # apparent magnitudes 
zmax   = lf.calzmax(zgal, mapp, 19, kcorr_func)
print(magabs) # magabs (Mabs - 5*log10(h)): -11.06523736 -14.60368681 -16.16156683
print(loglum) # loglum (L Lsun/h^2):  6.35809494  7.77347472  8.39662673 
print(zmax)   # zmax: 0.01 0.05 0.1 
#
# calculate the luminosity function 
#
zlo = 0; zup = 0.33
res = lf.callf(zlo, zup, zgal, zmax, loglum, skycov = 132.1)
print(res)
plt.errorbar(res[:,0], res[:,1], yerr = [res[:,2], res[:,3]], marker = '.' )
plt.xlabel(r"$\rm \log [L/(h^{-2}  L_{\odot})]$")
plt.ylabel(r"$\rm \log [\phi(L)  / (h^{-1}Mpc)^{-3}]$")
plt.legend() 
plt.show() 
```
</p>
</details>


<details><summary><b> conditional luminosity function </b>:</summary>
<p>

``` python 
from csstmock.utils import lftools
import numpy as np 
import matplotlib.pyplot as plt

zbin = [0, 0.33, 0.67, 1.0]
loglum_bin = np.arange(6, 13+0.2, 0.1); r = 1.45
skycov  = 20*2*np.pi*(1-np.cos(r*np.pi/180))/(np.pi/180)**2 # 20 sv3 region 
mag_cut = 19;
kcorr_func = np.poly1d([0.73, -0.54, -0.33]) 
Omega_M = 0.315; H0 = 67.4; 
label = 'sv3'; 
# igal, a, d, zgal, mag, kcorr, compl, igrp, imem, zgrp, mgrp, zmax
gal = np.load('temp/fig05/DESIDR9v2_sv3_zband19_for_CLF.npy')
mgrp    = gal[:,10]; mlo = 14.4; mup = 14.7
indx= (mgrp>mlo)&(mgrp<=mup)&(gal[:,4]<=19)
gal_data= gal[indx, :]
zgrp    = gal_data[:,9]
imem    = gal_data[:,8]
igrp    = gal_data[:,7]
compl   = gal_data[:,6]; compl = np.nan_to_num(compl, nan=1) 
kcorr   = gal_data[:,5]
mag_app = gal_data[:,4]
zgal    = gal_data[:,3]

    
lft = lftools(mag_cut = mag_cut, 
    zgal    = zgal, 
    mag_app = mag_app, 
    kcorr   = kcorr, 
    kcorr_func = kcorr_func, skycov = skycov, weight = compl, igrp = igrp, zgrp = zgrp)

for ii in range(3): 
    zlo   = zbin[ii]; zup = zbin[ii+1]; mlo = 13.5; mup = 13.8
    index = imem == 1 
    lfdata, numden = lft.run(zlo, zup, index = index, bootstrap = 1)
    np.savetxt('temp/fig02/DESIdr9v2_%s_clf_zband19_central_%.2f_to_%.2f.txt'%(label, zlo, zup), lfdata) 
    index = imem == 2 
    lfdata, numden = lft.run(zlo, zup, index = index, bootstrap = 1)
    np.savetxt('temp/fig02/DESIdr9v2_%s_clf_zband19_satellite_%.2f_to_%.2f.txt'%(label, zlo, zup), lfdata) 
#     igrp_uniq = np.unique( gal[gal[:,8] == 1, 7] )
#     indx = np.isin( gal[:,7],  igrp_uniq)
#     gal_data = gal[indx, :]
#     print(np.shape(gal_data) ) 
#     igrp    = gal_data[:,7]
#     zgrp    = gal_data[:,9]
#     zgrid   = lftools.build_zgrid(precision = 6, Omega_M = 0.315, H0 = 67.4)
#     z2ngrid = lftools.build_ngrid(zgrp, i = igrp, zgrid = zgrid)

#     indx   =  gal_data[:,8] == 2
#     gal_data= gal_data[indx,:] 
#     compl   = gal_data[:,6]; compl = np.nan_to_num(compl, nan=1) 
#     kcorr   = gal_data[:,5]
#     mag_app = gal_data[:,4]
#     zgal    = gal_data[:,3]
#     zgrp    = gal_data[:,9]
#     imem    = gal_data[:,8]
#     igrp    = gal_data[:,7]
    

    #------ central   ------
    #lfunc, numden = lft.run(zlo, zup, index = index&(imem == 1), bootstrap = bootstrap) 
    #lfdata = np.vstack([loglumc, Phi_cen_P]).T
    #np.savetxt('pipeline-paper2/temp/fig02/DESIdr9v2_%s_clf_zband19_central_%.2f_to_%.2f.txt'%(label, zlo, zup), lfdata) 
    #------ satellite ------
    #lfunc, numden = lft.run(zlo, zup, index = index&(imem == 2), bootstrap = bootstrap) 
    

``` 
</p>
</details>

<details><summary><b> app2abs( )</b>: Convert the apparent magnitudes to absolute magnitude </summary>
<p>

Return absolute magnitude or the base-10 logarithm of luminosity.

```python
import numpy as np 
from csstmock.utils import lftools
lf = lftools(H0 = 67.4, Om0 = 0.315) # initializing cosmology 

zgal   = np.array([0.01, 0.05, 0.1, 0.3, 0.5, 1.0])
mapp   = np.array([21, 21, 21.,  21,  21,  21, ])
kcorr_func = np.poly1d([0.73, -0.54, -0.33])  
loglum = lf.app2abs(zgal, mapp, kcorr = kcorr_func(zgal), Msun = 4.83)
magabs = lf.app2abs(zgal, mapp, kcorr = kcorr_func(zgal))
print(magabs)
print(loglum)
# magabs (Mabs - 5*log10(h)): -11.06523736 -14.60368681 -16.16156683 -18.74758902 -20.0579728 -22.16665048
# loglum (L Lsun/h^2):  6.35809494  7.77347472  8.39662673  9.43103561  9.95518912 10.79866019 ```
```

</p>
</details>

<details><summary><b> calzmax()</b>: calculate zmax of galaxies </summary>
<p>

Return zmax .

```python
import numpy as np 
from csstmock.utils import lftools
lf = lftools(H0 = 67.4, Om0 = 0.315) # initializing cosmology 
zgal   = np.array([0.01, 0.05, 0.1, 0.3, 0.5, 1.0])
mapp   = np.array([21, 21, 21.,  21,  21,  21, ])
kcorr_func = np.poly1d([0.73, -0.54, -0.33])  
zmax   = lf.calzmax(zgal, mapp, 21, kcorr_func)
print(zmax) 
```

</p>
</details>


<details><summary><b> Design</b></summary>
<p>


``` python 
import healpy as hp 
from utils import lftools

#
#--- luminosity function (zgal, mapp, kcorr, weight) 
#
dat = np.vstack([zgal, mapp, kcorr, weight, rank, igrp, zgrp, mgrp]).T
Msun    = 4.83 

#-----------------------------------------------------------------------------------------


pix = hp.ang2pix(256, ra, dec, lonlat = True) 
skycov = len( np.unique(pix) )*hp.nside2pixarea(256, degrees = True)
for ii in range(3): 
    zlo =  zbin[ii]; zup = zbin[ii+1]; 
    indx= (zlo < zgal)&(zgal < zup)
    dat_ = dat[indx, :] 
    loglum_  = lftools.app2abs(dat_[:,0], dat_[:,1], kcorr = dat_[:,2], Msun = Msun, use_h = True)
zmax    = self.calzmax(zgal, mag_app, mag_cut = mag_cut, zmaxgrid = self.zmaxgrid, zgrid = self.zgrid
    lf, numden = lftools.lf( dat_, zlo, zup, mcut, skycov = skycov) #, boostrap = 100, loglum_bin = np.arange(6, 13+0.1, 0.1) )
)
#
#--- conditional luminosity function (zgal, mapp, kcorr, weight, rank, igrp, zgrp, mgrp)
# 
for ii in range(3): 
    zlo = zbin[ii]; zup = zbin[ii+1]; 
    indx= (zlo < zgal)&(zgal < zup)
    dat_ = dat[indx, :]
    [clfc, clfs], [numdenc, numdens] = lftools.clf(dat_, zlo, zup, mcut) # , boostrap = 100, loglum_bin = np.arange(6, 13+0.1, 0.1) )

```
</p>
</details>


<details><summary><b> modify_igrp(igrp, rank, a, d): </b> clustering the repeat group ids by ra, dec  </summary>
<p>

``` python 
import matplotlib
import healpy as hp
import numpy as np 
import matplotlib.pyplot as plt 

def ruv2xyz(r, u, v):
    x = r*np.cos(v/180.0*np.pi)*np.cos(u/180.0*np.pi)
    y = r*np.cos(v/180.0*np.pi)*np.sin(u/180.0*np.pi)
    z = r*np.sin(v/180.0*np.pi)
    return x, y, z

def modify_igrp(igrp, rank, a, d): 
    # one igrp has >= 2 centrals,
    igrp = igrp.astype('float')
    uniq_igrp, counts = np.unique(igrp[rank==0], return_counts = True)
    from sklearn.cluster import KMeans
    import logging 
    indx = counts>=2
    
    if np.sum(indx) != 0: 
        igrp_tragets = uniq_igrp[indx]
        cnts_tragets = counts[indx]
        for igrp_, cnts_ in zip(igrp_tragets, cnts_tragets): 
            indx  = igrp_ == igrp 
            x,y,z = ruv2xyz(1, a[indx], d[indx]) 
            data  = np.vstack([x, y, z]).T 
            kmeans = KMeans(n_clusters=cnts_).fit(data)
            igrp[indx] = igrp[indx] + 1.0*kmeans.labels_/10**int(np.log10(cnts_)+1)
    return igrp

a0 = np.random.uniform(140, 150, 1)
d0 = np.random.uniform( -5,  15, 1)
a1 = np.random.normal(143, 0.3, 100); a2 = np.random.normal(145, 0.2, 50); a3 = np.random.normal(147, 1, 20)
d1 = np.random.normal(2.5, 0.3, 100); d2 = np.random.normal( 10, 0.2, 50); d3 = np.random.normal(  0, 1, 20)
igrp = np.hstack([ [0]*1+[1]*100+[1]*50+[1]*20])
rank = np.ones(171); rank[[0, 50, 125, 153]] = 0
a = np.hstack([a0, a1, a2, a3])
d = np.hstack([d0, d1, d2, d3])


igrp = modify_igrp(igrp, rank, a, d)
plt.scatter(a, d, c = igrp, s = 5)
plt.colorbar() 
plt.show() 
```
</p>
</details>

## random 

<details><summary><b> randsph(): </b>  Randomly uniform distribution on a box of sphere </summary>
<p>


``` python 
from csstmock.utils import star mask
ad      = starmask.sphrand(n=10000,box = [5, 15, 5, 15], xyz = False)
x, y, z = starmask.ruv2xyz(1, ad[:,0], ad[:,1]) 
```

</p>
</details>

