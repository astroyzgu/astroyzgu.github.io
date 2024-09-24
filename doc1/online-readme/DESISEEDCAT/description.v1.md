# The lsdr9-based catalog (v1)

**The galaxy catalog can be viewed at this [link](#the-list-of-galaxy-catalogs).**

#### The summary catalog 

We have reconstructed the summary catalog based on [DESI Legacy Imaging Surveys (dr9)](https://www.legacysurvey.org/dr9/description/), which has de-extinction magnitude limits of 21 on the r-band or z-band. The summary catalog covers ~20000 deg^2. It contains ~331M objects (might be star, galaxy or QSO). 

The primary selection is that: 

1. NOBS_{X} > 0, X = {g, r, z}, the object should be observed in each optical band; 
2. MORPHTYPE !=  'DUP', use the [five morphological types](https://www.legacysurvey.org/dr9/description/#morphological-classification) procedured by the fitting of [the Tractor](https://github.com/dstndstn/tractor);  MORPHTYPE == REX, DEV, EXP, SER, or PSF. 
3. apparent magnitude limits are mag_z <= 21 or mag_r <= 21; 
4. unique sources (Sources are resolved as distinct by only counting BASS and MzLS sources if they are both at Declination > 32.375° and north of the Galactic Plane, or, otherwise counting DECam sources.) 

<details><summary><b> The footprint of the sweep catalog (r<21|z<21) </b> </summary>
<p>

![footpring](footprint-dr9.png)

</p>
</details> 

<p> </p>

The total number of the objects with r < 21 or z < 21 is 331,569,898. In the actual process, the summary catalog is archived into six parts based on morphology and position, as shown in the Table.  

|folder name | number of record| id in the cutout catalogs |sum |
|------------|---------------- |-|--|
|ext_northngc| 40360233 |        0 - 40360232| ↓ 
|ext_southngc| 49149992 | 40360233 - 89510224|163318454
|ext_southsgc| 73808229 | 89510225 -163318453| ↑
||||
|psf_northngc| 44493809 |163318454 -207812262| ↓
|psf_southngc| 53155166 |207812263 -260967428|168251444
|psf_southsgc| 70602469 |260967429 -331569897| ↑
||||


* ext means that the morphological type is 'REX', 'EXP', 'DEV', or 'SER'. 
* psf means that the morphological type is 'PSF'.  
* north_ngc (b > 0 & dec > 32.375) use the filters of BASS_G, BASS_R, MZLS_Z, WISE_W1 and WISE_W2. 
* south_ngc and south_sgc use the filters of DECAM_G, DECAM_R, and DECAM_Z, WISE_W1 and WISE_W2.  

#### The galaxy sample selected from the summary catalog 

**All of the following tables can be consolidated from this sweep catalog (331,569,898 objects in total). As the spectroscopic redshift data continues to be updated, we have constructed different versions of galaxy catalogs using the following criterion.** 

<!-- <details style="padding-left: 2em;"><summary><b> Sample selection </b> </summary
<p> -->

1. appz < 21
2. z > 0.001. If no spec-z, we use photo-z instead.
3. foregroud mask
4. BITMASK != 1,5,6,7,8,9,11,12,13 (refer to [the DR9 bitmasks](https://www.legacysurvey.org/dr9/bitmasks/))
5. FRACFLUX_X < 0.5, FRACIN_X > 0.3, FRACMASKED_X < 0.4, for all X = {g, r, z} (refer to [the Tractor Catalog Format](https://www.legacysurvey.org/dr9/catalogs/))
6. remove STAR
    - if w/i spec regradless EXT or PSF, reject star using the REDROCK results of spectral fitting 
    - if EXT w/o spec but w/i gaia,  reject star using gaia - r < 0.6; 
    - if PSF w/o spec, reject them all. 

<!-- </p>
</details>  -->

<p> </p>

##### The list of galaxy catalogs


* **Y3 catalog (138012818):** The latest catalog updated to the jura version. In this version, we only use the archive spec-z collected by Zhou et al. 2021 and the DESI spec-z released in jura. If no spec-z, we use photo-z instead. 

    Gravity location: /home/yzgu/data/desi/yzgu/seedcat/data/lsdr9_prop.y3.v1.fits (.csv)

<p> </p>

* **Y1 catalog (137538086):** The catalog updated to the iron version. In this version, we only use the archive spec-z collected by Zhou et al. 2021 and the DESI spec-z released in iron. If no spec-z, we use photo-z instead. 

    Gravity location: /home/yzgu/data/desi/yzgu/seedcat/data/lsdr9_prop.y1.v1.fits (.csv)

<p> </p>

* **EDR catalog (136727324):** The catalog updated to the fuji version. In this version, we only use the archive spec-z collected by Zhou et al. 2021 and the DESI spec-z released in fuji, which **has been pulished**. If no spec-z, we use photo-z instead. 

    Gravity location: /home/yzgu/data/desi/yzgu/seedcat/data/lsdr9_prop.edr.v1.fits (.csv)

<p> </p>





##### The Data format of the cutout catlogs

|  colname       | dtype| comments
|----------------|------|--------
| 'igal'         |   i8 | Unique id in this catalog 0-331569897 (id in the cutout catalog)
| 'RA'           |   f8 | Right ascension at equinox J2000. 
| 'DEC'          |   f8 | Declination at equinox J2000. 
| 'z'            |   f8 | Redshift (PHOTZ or SPECZ). 
| 'zerr'         |   f8 | Error of redshift. 0.0001 is settled for 'non DESI-SPECZ' 
| 'zsrc'         |   i4 | Source of redshift. 0: 'PHOTZ';1,2:'non DESI-SPECZ';>=3:'DESI-SPECZ'  
| 'lmass_kcorr'  |   f8 | log10 of Stellar mass from K-correction. Unit: $h^{-2} M_\odot $ 
| 'lmass_cigale' |   f8 | log10 of Total mass of stars from cigale. Unit: $M_\odot$; ($h=0.7$; $\Omega_M = 0.3$)
| 'lsfr_cigale'  |   f8 | log10 of star formation rate from cigale. Unit: $M_\odot/\rm year$ 
| 'ldust_cigale' |   f8 | log10 of Estimated dust luminosity from cigale using an energy balance. Unit: $L_\odot$  
| 'mag_X'        |   f8 | Apparent magnitude, mag_X = 22.5 - 2.5log10(FLUX_X/MW_TRANSMISION_X). 
| 'kcorr_X_0.5'  |   f8 | kcorrect to z = 0.5, X = {g,r,z,w1,w2}. 
| 'MORPHTYPE'    |   S3 | Morphological types: "PSF", "REX", "DEV", "EXP", and "SER". 
| 'regionid'     |   i4 | 0, two tails; 1&2: ngc; 3&4: sgc; 
| 'tgttype'      |   i4 | 0, star; 1, galaxy; 2, QSO; -1, unclassified. 

<details><summary><b> Illustration of regionid </b> </summary>
<p>

![regionid01234](regionid01234.png)

</p>
</details> 

<p> </p>

Note: In order to be more concise, I have kept only the necessary information. Additional information can be obtained through the supplementary catalogs. Contact me.  

<p> </p>
<p> </p>

#### The supplementary infomation (building)

##### lsdr9_link*.fits

|  colname       | dtype| comments
|----------------|------|--------
| 'igal'         |   i8 | Unique id in this catalog 0-331569897 (id in the cutout catalog)
| 'RELEASE'      |   i8 | the record of processing run; A unique identifier is release,brickid,objid. 
| 'BRICKID'      |   i8 | brick ID [1,662174], encoding the sky position of brick; 
| 'OBJID'        |   i8 | catalog object number within this brick; 
| 'TARGETID'     |   i8 | Unique ID of spectroscopic targets; if not DESI targets, -99. 
|    DESI_TARGET | int64| Target masks record the reasons why each target was selected for DESI observations; refer to [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)
|    BGS_TARGET  | int64| also refer to [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)
|    MWS_TARGET  | int64| also refer to [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)
|    SCND_TARGET | int64| also refer to [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)



<!-- <details><summary><b> SED fitting using CIGALE </b> </summary>
<p>

| Key Parameters    | Configures |
|-------------------|-----------|
| SFH               |  exponentially declining
| e-folding time    | 10^8 - 10^10 yr (10 steps)
| age               | 5*10^7 - 10^10 yr (12 steps)
| SPS models        | BC03
| IMF                         | Chabrier (2003) 
| metallicity                 | 0.02 
| dust attenuation law        | Calzetti et al. (2000)
| E_BVs_young                 | 0.01-1.2 (13 steps)|
</p>
</details>  -->