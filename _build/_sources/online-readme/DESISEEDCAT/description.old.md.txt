# The lsdr9-based catalog (for internal communication)

## Overall description 
We have reconstructed the source catalog based on [DESI Legacy Imaging Surveys (dr9)](https://www.legacysurvey.org/dr9/description/), which has de-extinction magnitude limits of 21 on the r-band or z-band. The full catalog covers ~20000 deg^2. It contains ~120M extragalactic targets (galaxies or QSOs). 

####  Source Catalog

######  The selection from DESI Legacy Imaging Surveys (dr9)

The primary selection is that: 

1. NOBS_{X} > 0, X = {g, r, z}, the object should be observed in each optical band; 
2. MORPHTYPE !=  'DUP', use the [five morphological types](https://www.legacysurvey.org/dr9/description/#morphological-classification) procedured by the fitting of [the Tractor](https://github.com/dstndstn/tractor);  MORPHTYPE == REX, DEV, EXP, SER, or PSF. 
3. apparent magnitude limits are mag_z <= 21 or mag_r <= 21; 
4. unique sources (Sources are resolved as distinct by only counting BASS and MzLS sources if they are both at Declination > 32.375° and north of the Galactic Plane, or, otherwise counting DECam sources.) 
5. For the sources with non-PSF morphologies, all the sources are incorporated. These sources with PSF types are highly likely to be stars. Therefore, we only retained the sources that would be targeted by DESI, meaning those that have the opportunity to be spectroscopically observed by DESI. 

<details><summary><b> The footprint of the sweep catalog (r<21|z<21>) </b> </summary>
<p>

![footpring](footprint-dr9.png)

</p>
</details> 

###### Main catalog cutout from Source Catalong. 


<details><summary><b> safe1z21z5 </b> </summary>
<p>

 appz < 21
 tgttype != ‘STAR’
 usebits== 0 
 lmstar_cigale > 6
 z > 0

</p>
</details> 


All sources that are resolved (or extended), characterized by MORPHTYPE being either REX, DEV, EXP, or SER, are incorporated into the final catalog.
For point sources, identified by MORPHTYPE as PSF, it presents a challenge to differentiate between unresolved galaxies, stars, or distint quasars. 
Conservatively, the final catalog only includes those PSF sources that possess spectra, which have been classified into GALAXY, QSO, or STAR by Redrock.

1. Apply the foreground mask. Remove sources around the ... ... 
2. Objects with PSF morphologies are highly likely to be stars. It is difficult to effectively exclude stars from the sample using only photometric methods, which carries a high risk of introducing contaminants. Therefore, apart from spectroscopically confirmed extragalactic galaxies or quasars, we consider the remaining PSF-type objects to be stars.
3. Objects with non-PSF morphologies have extended profiles, which are more likely to be galaxies. For those successfully classified with spectral observations, stars are directly removed using the Redrock results of spectral fitting. If there are no spectral observations, we use gaia - r = 0.6 as the boundary to exclude stars. 

 

## Catalogs with spectroscopic redshifts

**Gravity location:** /home/cossim/DESI/yzgu/seedcat/produce/*.fits 

* lsdr9_prop{[zlevel](#zlevel)}.produce.fits (~21G)-- Main Catalog of galaxy properties
 
* lsdr9_link{[zlevel](#zlevel)}.produce.fits (~11G)-- link to DESI ID and some geometry selections

**Note:** use [zlevel](#zlevel) == 5 for the latest data of spectroscopic redshifts



<details><summary><b> spec-z fraction of galaxy sample in the entire catalog </b> </summary>
<p>

![z0](lsdr9-z0.compl.png)
![z1](lsdr9-z1.compl.png)
![z2](lsdr9-z2.compl.png)
![z3](lsdr9-z3.compl.png)
![z4](lsdr9-z4.compl.png)
![z5](lsdr9-z5.compl.png)

</p>
</details> 

   
      

### USAGE

``` python 
from astropy.table import Table
t1 = Table.read('lsdr9_prop5.fits') 
t2 = Table.read('lsdr9_link5.fits') 
reject_star = t1['tgttype']!='STAR'   # select galaxy, qso; reject star 
useflag     = t1['usebits']==0 # to avoid the very unreliable redshifts and feroground masks
magr_cut    = t1['mag_r']<19.5
isin_desi   = t2['isin_desi'] ==1 # apply the region cut
indx_seed   =(t2['iseed'] >=0)  # sources in the old version of seed catalog 

# select sample
t1 = t1[reject_star&useflag&magr_cut&useflag&isin_desi&indx_seed] 

# ... make some plots

```

<details><summary><b> example plot </b> </summary>
<p>

![BGS-spectroscopic-completeness](lsdr9-z5.compl.r19.5.produce.png)

</p>
</details> 


## The construction of the source catalog

All sources that are resolved (or extended), characterized by MORPHTYPE being either REX, DEV, EXP, or SER, are incorporated into the final catalog.
For point sources, identified by MORPHTYPE as PSF, it presents a challenge to differentiate between unresolved galaxies, stars, or distint quasars. 
Conservatively, the final catalog only includes those PSF sources that possess spectra, which have been classified into GALAXY, QSO, or STAR by Redrock.

* In one word, the catalog is constructed by **PSF(spec only)+REX+DEV+EXP+SER**

<!-- ```

``` -->



When compared to the dataset in Yirong’s work, the following improvements are notable:

* We have expanded the catalog from having a magnitude limit of mag_z <= 21 to include objects where either mag_z <= 21 or mag_r <= 21;
* we have incorporated the targets with MORPHTYPE == 'PSF' into the catalog; 
* we have introduced a new column, ‘tgttype’, which is used to filter out potential stars; 
* we have extended the catalog to include areas near the galactic plane where |b| <= 25. 

### The collections of DESI spectroscopic data 

**Gravity location:** /home/cossim/DESI/yzgu/rawdata/release/DESItgt_specz_{SPECPROD}.fits 

Overall view of the collection of DESI spectral data:

|    SPECPROD     | sci targets (  GALAXY      QSO     STAR) | Comments 
|-----------------|------------------------------------------|------
|    fuji         |  1712004 ( 1125635    90241   496128)    | Early data (released)
|    iron         | 20415123 (14179871  1645842  4589410)    | Year1 data (dr1)
|    iron20240409 | 44276250 (29704052  2757831 11814367)    | Year3 data (daily)
|    jura         |   -  | Year3 data (latest)

Selection criteria of the unique targets: 

   1.  OBJTYPE == 'TGT', fiber positioners should point to the sci targets (star, galaxy, or qso).  
   2.  ZWARN == 0, no redshift warning from REDROCK
   3.  maximum DELTACHI2, when one unique target has more than one observation.   

### tgttype='star', 'galaxy', 'qso'

<!-- ### Details 

```
                       EXT-morph     photstar specstar       PSF-morph   specgala  specqso      ALL
north_ngc     |        40,360,233 ( 5,354,511   36,181)  |  44,493,809  (  39,667   245,208) |    84,854,042
south_ngc     |        49,149,992 ( 7,801,986   27,138)  |  53,155,166  (  64,443   503,568) |   102,305,158
south_sgc     |        73,808,229 (12,407,742   18,981)  |  70,602,469  (  50,008   380,406) |   144,410,698
    total     |       163,318,454                        | 168,251,444  ( 154,118 1,129,182) |   331,569,898

* EXT-morph means that the morphological type is 'REX', 'EXP', 'DEV', or 'SER'. 
* PSF-morph means that the morphological type is 'PSF'.  
```  -->

## Known issues or to do lists: 
<!-- 1. 'mstar' is got from 'KCORRECTv4.0', need to update to CIGALE's results, unit: log10(Mstar*h/Msun) -->
```
    *. regionid only has [1,2,3]
    *. Random sample and spec-z completeness are need! 
    *. lsdr9_link, ``ntile'' columns
    *. jura version is released internally. Jura consists of SV and the Y3 sample of main survey observations processed using the latest version of the spectroscopic pipeline. There are roughly 46 million unique, good redshifts in this sample, with 31.4M redshifts being extragalactic. Jura includes good spectra and redshifts for 13.0M BGS, 5.8M LRG, 10.7M ELG, 2.2M QSO, and 10.8M stellar main survey targets.
    *. add a examples of the SED fitting
```

## Details 

### 3.merge_sweeps.py






<!-- 
### Data format of lsdr_shape.fits () 


### Data format of lsdr9_healpix.fits (163,665,614, on going) : 
```
    igal      float   {igal}.1, north_ngc; {igal}.2, south_ngc; {igal}.3, two tails; {igal}.4, south_sgc;   
   compl_z21  float   {igal}.1, north_ngc; {igal}.2, south_ngc; {igal}.3, two tails; {igal}.4, south_sgc;   
``` 





    lsdr9_id.fits # galaxy ids and some geometry selections
    lsdr9.z5.fits # updating catalogs of galaxy properties related to redshits 


Cutout to the seed catalog:  

    EXT morph + PSF morph with spec-z  = Total number
    138315649 +                     0  =  138,315,649 (old seed catalog)


seedcat-origin(138): origin seed catalog we used 
seedcat-extend(138): 'PSF' morphology is involved, and deeper

----------------------------------------------------------------
                    spectroscopic redshift fraction 
----------------------------------------------------------------
              seedcat-origin   seedcat-extendz21
north_ngc         31,450,384          84,116,567
south_ngc         41,237,608         102,072,629
south_sgc         65,627,657         144,023,595
    total        138,315,649         330,212,791



The the comparsion of total number can be seen as follow. 

    EXT morph + PSF morph with spec-z  = Total number
    162408108 +               1257506  =  163,665,614 (current version)
    138315649 +                     0  =  138,315,649 (old version of seed catalog)
 -->


<!-- We have made significant enhancements to the LSDR9-based catalog,

1. We have expanded the source catalog from ~140M to ~170M ([See more deteils](#the-selection-from-legacy-survey-dr9)).
2. The number of galaxies with spectroscopic redshifts has doubled, increasing from 10M to 20M. If you need spectroscopic data only, please see [here](#the-collections-of-desi-spectroscopic-data). 
3. We have introduced a new column, ‘tgttype’, which is used to filter out potential stars; 
4. We have used CIGALE to determining stellar masses ([See more details](#sed-fitting-of-cigale)) .  -->
