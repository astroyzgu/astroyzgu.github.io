# Mock catalog of mockDESIDR9  

/home/xhyang/work/MOCK9tian/MGRS/data/

### Overview of data

Y1 --> 108510637 | ngc-specz --> 56711732 | ngc-photz --> 56707247
* [\<subtitle\>/](#) = Y1
  * [mockDESIDR9_9tian.fits](#mock-galaxy-catalog) 
  * [mockDESIDR9_9tian_obs.fits](#matched-with-desi-ngc-observation)
  * [mockDESIDR9_9tian_mask.fits](#foreground-masking) 
  * [\<ztype\>/](#Sets-of-redshifts) = 'specz', 'photz' 
    - [mockDESIDR9_9tian_galaxy.fits](#reduction-of-mock-galaxy-catalog)  
    - [mockDESIDR9_9tian_group.fits](#group-catalog-based-on-the-galaxy-catalog)


##### Mock galaxy catalog 

Filename: mockDESIDR9_9tian.fits

The mock galaxy catalog is based on Jiutian-1Gpc N-body simulation (Planck18 cosmology). The basic information is that 1Gpc/h, 6144^3 particles with particle mass = 3.723E-08 Msun/h. The .txt version with similar format can be accessed online:
   - https://gax.sjtu.edu.cn/data/CSST/CSST.html

```
Data format:

(0) imock       --- id of mock galaxy catalog (fits version only)
(1) hosthaloId  --- halo host ID
(2) rank        --- rank of subhalo (0=central, most massive one; 1,2,3,...=satellite)
(3) trackId     --- subhalo trackID
(4) ra
(5) dec
(6) r           --- real space comoving distance, Mpc/h)
(7) z_cos       --- cosmological redshift
(8) z_obs       --- obsvered redshift which considering the peculiar velocity
(9) snapnum     --- snapshot number of the simulation (0-127 in Jiutian Simulation)
(10) lm_fofhalo --- the logarithm of host halo mass (log Msun/h) given by the jiutian Simulation
(11) appz       --- apparent magnitude in z-band (use this to make the test, here you can apply the average k-correction)
(12) lm_peaksub --- subhalo maximum mass or peak mass given by jiutian Simulation (see Han et al. 2018)
(13) loglum     --- the logarithm of luminosity with K-correction.

       (1)     (2)       (3)          (4)          (5)         (6)       (7)       (8)       (9)      (10)      (11)      (12)      (13)
        -1      0 1333017857   56.6081734  -12.4620619      13.181   0.00440   0.00211 127.00000  -1.00000  20.07290   9.87192   6.00000
   6547256      0    5685873  322.7909546   -1.4668103      11.116   0.00371   0.00400 127.00000  11.76872   9.71988  11.77960   9.99438
   1112811      0   12383956  310.0267639  -11.1690731      13.866   0.00463   0.00545 127.00000  12.60740   9.94583  12.36237  10.09687
``` 

##### Matched with DESI NGC observation 
The 3-parameter sampling catalog (used to assign other properties by sampling from DESI). 

```
Data format: 

(0)  imock   ----- id of mock galaxy catalog (fits version only)
(1)  iseed   ----- id of seed catalog, start from 0.
(2) z_mock      -- no use
(3) loglum_mock -- no use
(4) lmhalo_mock -- no use
(5) z_desi      -- no use
(6) loglum_desi -- no use
(7) lmhalo_desi -- no use

     (1)        (2)      (3)       (4)       (5)       (7)       (7)
  14967667   0.00211   6.00000   9.87192   0.00173   5.99152  10.79470
   3645395   0.00400   9.99438  11.77960   0.00768   9.53972  11.63880
   3645395   0.00545  10.09687  12.60740   0.00768   9.53972  11.63880
```

##### Sets of redshifts 

\<ztype\> = 'cosmz', $\sigma_z = 0$

\<ztype\> = 'specz', $\sigma_z = \Delta v/c$, $\Delta v = 35km/s$


\<ztype\> = 'csstz', $\sigma_z = \rm 0.003*(1+specz)$

\<ztype\> = 'photz', $\sigma_z = \rm (0.01 + 0.015specz)*(1+specz)$

#####  Reduction of mock  galaxy catalog

Filename: mockDESIDR9_9tian_\<ztype\>_galaxy.fits

```
Data format: 

(0) imock   ----  id of mock galaxy catalog, start from 0.
(1) ra      ----  RA
(2) dec     ----  DEC
(3) z       ----  redshift; if Photo, dz = 0.01 + 0.15*z is applied.
(4) iseed   ----  id of matched seed catalog, start from 0.  
(5) lmass   ----  assigned properties, the following is same as seed catalog
(6) appz    ----     ...
(7) appr    ----     ...
```

##### Foreground masking 

The foreground sources include Globular Clusters, Planetary Nebulae, Nearby Large Galaxies, and gaia stars with G < 16. It is based on the external catalogs Legacy Survey dr9:

   - https://www.legacysurvey.org/dr9/external/#external-catalogs-used-for-masking

```
MGRS masked areas are estimated by ~6 times random points (RAND/randoms/*.fits). 
                    masked/  total [deg^2]
   lsdr9-ngc   ---  476.78/9621.98 [deg^2]
   lsdr9-sgc   ---  452.70/8601.19 [deg^2]
   lsdr9-2tail ---    8.67/ 127.10 [deg^2]

Application of foreground mask:

      number   filename
   138315649   SEED/seedcat_foregroundmask
   108510637   MGRS/mockDESIDR9Y1_9tian0_z0.0_1.0_foregroundmask
   127762754   MGRS/mockDESIDR9sv3_9tian0_z0.0_1.0_foregroundmask
```

```
Data format:

(0) iseed/imock 
(1) ra
(2) dec
(3) mask --- 1: be masked; 0: not be masked

        (1)          (2)      (3)
    226.6045532  -3.8050163    0
    219.0343323 -12.0410833    0
    219.7634277  -5.5686326    0
```

##### Group catalog based on the galaxy catalog 
```
Data format: 

(1) imock   ----  id of mock galaxy catalog, start from 0.  
(2) z       ----  redshift; if Photo, a scatter with dz = 0.01 + 0.15*z is applied. 
(3) igrp    ----  group id
(4) rank    ----  0 == central; 1 == satellite.  
(5) mgrp    ----  the logarithm of group mass
```




##### NGC galaxy/group catalog

* galaxy catalog 

Photometric   redshift version: mockDESIDR9sv3_9tianPhoto_NGC_reduction1.fits # 66793215 galaxies (dz = 0.01 + 0.15*z)
Spectroscopic redshift version: mockDESIDR9sv3_9tianSpec_NGC_reduction1.fits  # 66797588 galaxies (dz = a very small value)

Data format: 
(1) imock   ----  id of mock galaxy catalog, start from 0.  
(2) zgal    ----  redshift; if Photo, a scatter with dz = 0.01 + 0.15*z is applied. 
(3) igrp    ----  group id
(4) rank    ----  0 == central; 1 == satellite.  
(5) mgrp    ----  the logarithm of group mass

The Msun and average k-correction of z-band (see Yang et al. 2021): 

	Msun = 4.5; kcorr@z=0.5 = 0.73*z**2 - 0.54*z - 0.33 


#------ Mock galaxy catalog: 

It can be downloaded use the following link: 

   https://gax.sjtu.edu.cn/data/CSST/data/mockDESIDR9sv3_9tian.gz

data format: 

(1) halo ID
(2) subhalo ID (0=central)
(3) subhalo trackID
(4) ra
(5) dec
(6) r (real space comoving distance, Mpc/h)
(7) z_cos
(8) z_obs (with RSD)
(9) snapshot number of the simulation
(10) host halo mass (log Msun/h)
(11) apparent magnitude in z-band (use this to make the test, here you can apply the average k-correction)
(12) subhalo maximum mass
(13) luminosity with K-correction. 


## Catalogs for LF and CLF 

```
#-- Catalog Generator (mag < 21, 0 < zgal < 1)
# >> /home/yzgu/data/desi/mock/mockDESIdr9sv3/data/
* group catalog (NGC) of mockDESI    ->  mockgrpfDESIDR9sv3_ngc_zband21_for_CLF.npy (71443728, Δz = 0.01+z*0.015) 
* mockDESI catalog (NGC) of 9tian    ->  mockhbt+DESIDR9sv3_ngc_zband21_for_CLF.npy (72619785, same with wangyr)
# >> 
* group catalog (NGC) of DESI dr9    ->      DESIDR9v2_ngc_zband21_for_CLF.npy   ( 66229628)
* group catalog (sv3) of DESI dr9    ->      DESIDR9v2_sv3_zband21_for_CLF.npy   (r<1.45deg, 933635)
#
#-- Data fromat of *_for_CLF.npy:
#
#     0, 1, 2,    3,   4,     5,     6,    7,    8,    9,   10
#   igal, a, d, zgal, mag, kcorr, compl, igrp, rank, zgrp, mgrp
#----------------------------------------------------------------
#  0) galaxy id
#  1) ra
#  2) dec 
#  3) redshift  of galaxy 
#  4) apparent magnitude 
#  5) k-correction 
#  6) compleness (0-1)
#  7) group id 
#  8) rank == 0, central; 
#  9) redshift  of central galaxy in the group
# 10) halo mass of group

```


### Detials 
``` python 
import numpy as np 
topdir = '/home/xhyang/work/MOCK9tian/MGRS/data/group/'
savdir = '../raw/'
data   = np.loadtxt(topdir+ 'mockDESIDR9sv3_9tian_NGC_galaxyID')
data   = np.save(savdir+ 'mockDESIDR9sv3_9tian_NGC_galaxyID.npy', data)
data   = np.loadtxt(topdir+ 'mockDESIDR9sv3_9tian_NGC_1')
data   = np.save(savdir+ 'mockDESIDR9sv3_9tian_NGC_1.npy', data)
data   = np.loadtxt(topdir+ 'mockDESIDR9sv3_9tian_NGC_group')
data   = np.save(savdir+ 'mockDESIDR9sv3_9tian_NGC_group.npy', data)
data   = np.loadtxt(topdir+ '../mockDESIDR9sv3_9tian0_z0.0_1.0')
data   = np.save(savdir+ 'mockDESIDR9sv3_9tian0_z0.0_1.0.npy', data)
```

## mock catalog 

location: /home/xhyang/work/MOCK9tian/MGRS/data/

```
mockDESIDR9sv3_9tian0_z0.0_1.0: 
0  ihal    -  haloID from jiutian simulation
1  rank    -  rank   from jiutian simulation, ranked by subhalo mass (0=central)
2  isub    -  trackID from simulation
3  a       -  ra
4  d       -  dec
5  r       -  comoving distance
6  zcos    -  cosmology redshift 
7  zgal    -  z_obs (with RSD)
8  snap    -  snapshot number of the simulation
9  mhal    -  host halo mass (log Msun/h) (from fof)
10 mag     -  apparent magnitude in z-band 
11 msubmax -  subhalo maximum mass
12 loglum  -  luminosity without K-correction.
```

|   hid |rank |      sid |          ra |         dec |      r |    zcos |  zobs  |    snap |      mag  |     lmh  |   msmax  |luminosity |
|-------|-----|----------|-------------|-------------|--------|---------|--------|---------|-----------|----------|----------|-----------|
|     -1|  0  |1333017857|  56.6081734 | -12.4620619 | 13.181 | 0.00440 |0.00211 |127.00000|  -1.00000 | 15.51061 |  9.87192 |    7.82492|
|  84777|  1  |  3501299 | 226.6045532 |  -3.8050163 | 13.580 | 0.00453 |0.00314 |127.00000|  13.66319 |  9.50953 | 12.70732 |   10.25187|
|  89496|  2  |  5453742 | 219.0343323 | -12.0410833 | 11.995 | 0.00400 |0.00459 |127.00000|  13.36263 |  9.55280 | 12.03627 |   10.12768|
|  84777|  7  | 11953855 | 219.7634277 |  -5.5686326 | 13.572 | 0.00453 |0.00613 |127.00000|  13.66319 | 10.52010 | 11.54998 |    9.84899|
|  84777| 69  | 11953917 | 221.8530273 |  -6.4959536 | 13.609 | 0.00454 |0.00442 |127.00000|  13.66319 | 13.47777 | 10.96005 |    8.66726|

## group catalog based on the mock catalog 

mock group catalog (location: /home/xhyang/work/MOCK9tian/MGRS/data/group)

group catalog format: 

``` 
# >>> wc mockDESIDR9sv3_9tian_NGC_*
#          0 mockDESIDR9sv3_9tian_NGC_BCG    ???
#       8780 mockDESIDR9sv3_9tian_NGC_C1     ???
#   47579670 mockDESIDR9sv3_9tian_NGC_prop   ??? (igrp, rich, ..., unknown)
#   50657568 mockDESIDR9sv3_9tian_NGC_group  ???  (7 columns; 50657568)
#   71443728 mockDESIDR9sv3_9tian_NGC_galaxyID *  (2 columns; 71443728)
#   71443728 mockDESIDR9sv3_9tian_NGC_link   ??? (4 columns) 
#   71443728 mockDESIDR9sv3_9tian_NGC_weight ??? (2 columns) 
#   71443728 imockDESIDR9sv3_9tian_NGC_1
#   71443728 imockDESIDR9sv3_9tian_NGC_2
``` 

```
|--- galaxy files: (71443728 galaxies )
                 *_weight|     *_galaxyID   |             i*_1  |                i*_2|
 ???                ???  | igal     zgal    |  igal   igrp rank |       ???       ???|
   1   33.2547950744629  |   2   0.01147    |     2   6470  1   |         1     13156|
  56   147.181640625000  |   4   0.00216    |     4  17515  2   |         1    143635|
  56   2.46862006187439  |   5   0.01695    |     5   3365  2   |         1    170044|
   4   81.4249649047852  |   6   0.00969    |     6 403545  1   |         1    189379|
  56   138.534973144531  |   7   0.00130    |     7   3365  2   |         1    189455|
note:  
*_galaxyID: galaxy id, redshift 
*_1 (4 columns): galaxy id, group id, rank, auxiliary ID (not used)
*_2 (2 columns): group  id, member galaxy id in the galaxy catalog
rank: rank == 1, central (brightest); rank == 2, satallite; 
igal: galaxy id in seed mock catalog (mockDESIDR9sv3_9tian0_z0.0_1.0.npy), start from 1, 
igrp: group  id in group catalog (*_group), start from 1
```

``` 
|--- group file: (50657568 groups)
>>> wc mockDESIDR9sv3_9tian_NGC_group
>>> 50657568   354602976  3292741920 mockDESIDR9sv3_9tian_NGC_group
                                                        *_group |
    igrp richness alpha     delta      zgrp      mgrp      lgrp |
       1 5206  251.2349   55.9615    0.0556   15.1421  717.7900 |
       2 3574  272.9934   54.1780    0.0478   14.9677  568.0316 |
       3 3166  247.3300   16.3576    0.0427   14.8307  396.5148 |
       4 3031  136.6318    3.0663    0.0446   14.8296  396.9393 |
       5 3013  196.8399   -9.2735    0.0880   15.2049  833.1750 |
     ...  ...       ...       ...       ...       ...       ... | 
50657567    1  124.5703   44.5025    0.4868   11.8998    1.3523 |
50657568    1  121.9167   69.2110    0.8988   12.9068    6.9020 |
note: 
*_group: group id, richness, ra, dec, redshift, log M_h/(M_sun/h), L_group (10^10Lsun/h/h)
   igrp: group id, start from 1
``` 



``` 
 >>> mockDESIDR9_9tian_NGC_prop
   igrp   rich                                                                 mgrp
      1   5206  1194293  2827.631     1.681   717.790     0.183     0.000    15.142     2.759   957.194
   -28.1049   -82.6447   129.3534   156.0701    0.0527    0.1379  -16.4293   11.5408    1.0000    4.3845    0.9770    0.0108  122.1677   10.6630   -0.3772   19.2312
   -29.6423   -87.2357   136.4079   164.6229    0.0556    1.5416  -19.7628   13.3432    1.0000    4.3849    0.9767    0.0108   85.2156   11.8181   -0.3786   16.0262
   -29.6199   -82.3887   129.4770   156.2995    0.0528   10.5450  -22.7576   15.0471    1.0000    4.3673    0.9762    0.0108    0.0000   14.5043   -0.3773   12.9465
   -26.3851   -79.9086   123.7641   149.6633    0.0505    6.3539  -22.2076   15.0471    1.0000    4.3935    0.9737    0.0108    1.0000   14.4572   -0.3762   13.3987
```

