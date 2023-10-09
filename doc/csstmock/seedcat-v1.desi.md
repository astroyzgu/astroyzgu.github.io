# seedcat-v1

Number: 138315649 galaxies(~18000 deg^2) totally including 2.7% specz(~3700deg^2).

```
Gravity location: DESIDR9_galaxy_comb.npy 

data format:

column 0: igal          -  galaxy id           
column 1: ra
column 2: dec
column 3: z             - photometric redshift. spectroscopic redshift if availabe  
column 4: magabs_z      - z-band absolute magnitude  (with k-correction_{0.5}^{z})
column 5: loglum_z      - z-band luminosity in log10 scale, log10(L/Lsun/h/h), with k-correction_{0.5}^{z}, Mr_{sun}=4.83)
column 6: magabs_r      - r-band absolute magnitude  (with k-correction_{0.5}^{r})
column 7: loglum_r      - r-band luminosity in log10 scale, log10(L/Lsun/h/h), with k-correction_{0.5}^{r}, Mr_{sun}=5.39)
column 8: zerr          - redshift error  (spec-z 0.0001; no redshift -99; photo-z other value.)
column 9: lmass         - stellar mass in log10 scale, log10(M*/Msun), by by kcorrect4.2
column 10: kcorr_z      - z-band K-correction to z=0.5, by kcorrect4.2 
column 11: magapp_z     - z-band apparent magnitude
column 12: kcorr_r      - r-band K-correction to z=0.5, by kcorrect4.2
column 13: magapp_r     - r-band apparent magnitude (col7 = -2.5*col13 + 4.83 + 5log(h), h = 0.683 )
column 14: select       - used to select sample 

                          if select == -1, objects in NGC's two tails
                          if select >= 0,  the magnitude-limit sample (magapp_z < 21) in NGC and SGC. 
                          if select >= 1,  the sample with successful redshift (spec-z and phot-z). 
                            * All objects with spec-z from archive or DESI would be included. 
                            * The objects with phot-z require the 5-band detection with low contamination,  
                                FLUX_[g,r,z,w1,w2] > 0,  
                                FRACFLUX_[g,r,z]   < 0.5, 
                                FRAC_IN_[g, r, z]  > 0.3, 
                                FRACMASKED_[g,r,z] < 0.4.
                          if select >= 2, objects with spec redshift [DESI and archives]. 
                          if select >= 3, objects with DESI spec redshift. 

                        - zonly sample;  select >= 0
                        - main  sample; (select >= 1)|(0 < zerr <= 0.0001)
                        - spec  sample; (select >= 2)|(0 < zerr <= 0.0001)
```


``` python 
import numpy as np 
dat = np.load('DESIDR9_galaxy_comb.npy') 
dat = dat[dat[:,14] >= 0, :]      # zonly sample
indx_spec = (dat[:, 8] <= 0.0001)&(dat[:,8] > 0)
indx_phot = (dat[:,14] >= 1) 
dat = dat[indx_spec|indx_phot, :] # main  sample
dat = dat[indx_spec|(dat[:,14] >= 2), :] # spec  sample
```

``` python 
5band_weight.npy (138315649, 3)  
col1: galaxy id in seed catalog
col2: z-band weight (cover 9253.21 NGC and 8016.51 SGC)
col3: r-band weight (cover 9251.32 NGC and 7994.90 SGC)
Note: this version carefully consider the border of survey and region which has bad photometrics. Weight is set as 0 when galxy located in the border of survey or the region which its 5-band success rate < 0.7.
```

### geometry supplyments

**geometry supplyments(see geo.ipynb)**

* **by galaxy id (by_igal)**

| name          |coverage (sqdeg) <br> nside = 128, 256|  description        |
| ------------- |---|-------------------- |
|`igal_sv3_r1.45.npy`| (189.5,   159.4)  |igal - galaxies located in the sv3 region within r < 1.45 degree (132.1 sqdeg)	
|`igal_ngc.npy`      | (9679.4, 9610.2)  |igal - galaxies located in NGC without two tails 
|`igal_sgc.npy`      | (8674.1, 8584.1)  |igal - galaxies located in SGC 
|`igal_iron.npy`     | (12735.6,12299.2) |igal - galaxies located in the region of spec observation of iron release (r < 1.628 deg)

* **by sector id, nside = 128 (by_isec)**

| name          |coverage (deg^2) <br> nside = 128 |  description        |
| ------------- |----------------------------------|--------------------|
|`ipix_sv3_r1.45.npy`| 189.5  |sector id  - galaxies located in the sv3 region within r < 1.45 degree (132.1 sqdeg)	
|`ipix_ngc.npy`      | 9679.4 |sector id  - galaxies located in NGC without two tails 
|`ipix_sgc.npy`      | 8674.1 |sector id  - galaxies located in SGC 
|`ipix_iron.npy`     | 12735.6 |sector id  - galaxies located in the region of spec observation of iron release (r < 1.628 deg)
|`ipix_border_ngc.npy`|425.3 | sector id, which is the border of NGC without two tails
|`ipix_border_sgc.npy`|629.7 | sector id, which is the border of SGC 
|`ipix_abnormal.npy`  | | sector id, which have the low success rate of redshift, $P_{\rm succ} < 0.7$



* **safe galaxy sample (safe)** $(P_{\rm succ} >= 0.7)\&(f_{\rm edge} = 0)$, see below. 

| name          |coverage (sqdeg) |description        |
| --------------|-----------------|--------------------|
|ipix_safe1.npy |                 |  $(P_{\rm succ} >= 0.7)\&(f_{\rm edge} = 0)$  
|igal_safe1.npy |                 |  $(P_{\rm succ} >= 0.7)\&(f_{\rm edge} = 0)$ 

``` python 
# dataio
``` 

### weight supplyments

**Key properties (see prop.ipynb)**
 * Redshift success rate: $P_{\rm succ} = \rm main/zonly$ 
 * Spectroscopic completeness: $P_{\rm comp} = \rm spec/main $
 * Surface number density: $\rm \Sigma = ngal/Area$ ($\rm deg^-2$)


- general porperies as a function of magnitude cut

| general porperies  |shape|  description        |
|--------------------|-----|---------------------|
| `prop_seed.magcutz.npy`  | (26,3) |**as a function of magnitude cut** <br> col1: the cut of z-band magnitude $\rm cut_z$, 16, 16.2, 16.4, ..., 21 <br> col2: success rate of redshift, $P_{\rm succ}$, as a function of $\rm cut_z$; <br> col3: completeness of spectroscopic redshift, $P_{\rm comp}$, as a function of $\rm cut_z$; | 
| `prop_ngc.magcutz.npy`  | (26,3) |**as a function of magnitude cut** <br> col1: the cut of z-band magnitude $\rm cut_z$, 16, 16.2, 16.4, ..., 21 <br> col2: success rate of redshift, $P_{\rm succ}$, as a function of $\rm cut_z$; <br> col3: completeness of spectroscopic redshift, $P_{\rm comp}$, as a function of $\rm cut_z$; | 
| `prop_sgc.magcutz.npy`  | (26,3) |**as a function of magnitude cut** <br> col1: the cut of z-band magnitude $\rm cut_z$, 16, 16.2, 16.4, ..., 21 <br> col2: success rate of redshift, $P_{\rm succ}$, as a function of $\rm cut_z$; <br> col3: completeness of spectroscopic redshift, $P_{\rm comp}$, as a function of $\rm cut_z$; | 
| `prop_iron.magcutz.npy` | (26,3) |**as a function of magnitude cut** <br> col1: the cut of z-band magnitude $\rm cut_z$, 16, 16.2, 16.4, ..., 21 <br> col2: success rate of redshift, $P_{\rm succ}$, as a function of $\rm cut_z$; <br> col3: completeness of spectroscopic redshift, $P_{\rm comp}$, as a function of $\rm cut_z$; | 



| fracmap.fits| general porperies  |shape|  description        |
|-------------| ------------- |-----| -------------------- |
|HDU0| | | |
|HDU1| `prop_suvery.magz.npy` | (-1,4) |**as a function of magnitude z** <br> col1: z-band magnitude $\rm mag_z$ <br> col2: surface number density, $\Sigma$ ($\rm deg^-2$), as a function of $\rm mag_z$; <br> col3: success rate of redshift, $P_{\rm succ}$, as a function of $\rm mag_z$; <br> col4: completeness of spectroscopic redshift, $P_{\rm comp}$, as a function of $\rm mag_z$; | 
|HDU2| `prop_ipixel.hp128.npy` |(-1,4)|**dividing into healpy subregions** <br> col1: sector id, $\theta_i$, (nside = 128); <br> col2: $\Sigma$ <br> col3: $P_{\rm succ}$ <br> col4: $P_{\rm comp}$| 	
|HDU3| `prop_ipixel.magz.hp128.npy` |(-1,-1,3)|dim1, $\theta_i$ <br> dim2, $\rm mag_z$ <br> dim3, properites. col1: $\Sigma$; col2: $P_{\rm succ}$; col3: $P_{\rm comp}$| 
| | prop_ipixel.mangle.npy |(-1,4)|**dividing into mangle subregions** <br> col1: sector id, $\theta_i$, (nside = 128); <br> col2: $\Sigma$ <br> col3: $P_{\rm succ}$ <br> col4: $P_{\rm comp}$| 	
| | prop_ipixel.magz.mangle.npy |(-1,-1,3)|dim1, $\theta_i$ <br> dim2, $\rm mag_z$ <br> dim3, properites. col1: $\Sigma$; col2: $P_{\rm succ}$; col3: $P_{\rm comp}$| 	

``` python
import csstmock utils import fracndim
data = fracndim(data, bin_list = [], mask)
   '''
   parameter:
   ----------
   data: array-like, list
         input data to split into subsample
   bin_list: 
	 the list of bins  to split into subsample
   mask: array-like, bool 
         if true, tract as numerator.
   return: 
   ----------
   frac: array-like 
       the data of fraction (shape depends on the bin_list)
   fracerr: 
   bin_list: array-like
       the list of bins 
   '''

```
