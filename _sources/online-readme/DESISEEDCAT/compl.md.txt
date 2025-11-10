# lss catalog

## spectroscopic redshift rate ($R$) 

## $R(\theta, x)$

$\theta_i$ - galaxy angular position, dependent on survey progress, if been surveyed. 

$x_i$ - galaxy properties, dependent on survey strategy, how been surveyed.  

$\theta$ = [ntile_dark, ntile_bright, contimation... ] 

$x$ = [mag, color]

光谱红移比例主要取决于三大方面，星系巡天的实际执行情况，目标选择策略和目标本身的红移测量难度。显然，天区整体的光谱红移比例取决于当前区域被光谱观测的次数，也就是星系巡天的实际执行情况。假如这个天区没有光谱巡天观测，则光谱红移比例为0。而如果天区有历史的存档数据，且随着被多次的光谱巡天覆盖， 则整体光谱红移的比例会显著升高。 此外，天区内具体获取光谱红移的优先级取决星系巡天的选源策略。 星系巡天的选源策略由科学目标决定， 一般与星系的测光数据（星等和颜色等）关联。 此外，由于巡天本身的探测极限， 在相同条件下暗弱的源较难获取高质量的光谱，进行可靠的红移测量的的难度也会增加。 因此，一般光谱红移的比例会与视星等直接关联。 随星等越暗，光谱红移的成功率越低。

在具体操作中，巡天策略的实际执行情况被量化为目标被实际巡天覆盖的次数。 因为DESI的巡天分为DARK和BRIGHT两大类，执行情况的参数为被BRIGHT巡天覆盖的次数ntile_bright和被DARK巡天覆盖次数ntile_dark。 在巡天策略方面， DESI的目标选取与一系列测光数据都有关联。 在这里我们仅考虑5个星等和4个颜色与光谱红移比例具有潜在的相关性。 

<!-- 为了对比，我们在这里展示z波段视星等关联。  -->



### The supplementary catalog (building)

#### The photometric infomation based on the DESI legacy survey dr9
<!-- The photometric infomation based on the DESI legacy survey dr9  -->

|fixed with photomatric data|  | 
|-|-| 
|[lsdr9-info.fits](#data-format-of-lsdr9_info.fits) | from the sweeps catalog |
|[lsdr9-id.fits](#Data-format-of-lsdr9_id.fits)| Unique ID of the photometric ojects  |
|[lsdr9_target.fits](#Data-format-of-lsdr9_target.fits) | Unique ID of the potential spectroscropic targets |
|[lsdr9_seedold.fits](#Data-format-of-lsdr9_seedold.fits) |  |
|[lsdr9_mask.fits](#Data-format-of-lsdr9_info.fits) |  |
|[lsdr9-frac.fits](#Data-format-of-lsdr9_info.fits) |  |
|[lsdr9_tgttype.fits](#Data-format-of-lsdr9_tgttype.phot.fits) |  |
|[lsdr9_kcorr.fits](#Data-format-of-lsdr9_tgttype.phot.fits) |  |
|[lsdr9_cigale.fits](#Data-format-of-lsdr9_tgttype.phot.fits) |  |
|[lsdr9_tile.fits](#Data-format-of-lsdr9_tile.fits) |  |
|[lsdr9_nspec.fits](#Data-format-of-lsdr9_npsec.fits) |  |

|updated with redshift |  | 
|-|-| 
|[lsdr9_tgttype.{zsrc}.fits](#Data-format-of-lsdr9_tgttype.{zsrc}fits)|  |
|[lsdr9-kcorr.{zsrc},fits](#Data-format-of-lsdr9_tgttype.{zsrc}fits) |  |
|[lsdr9-cigale.{zsrc}.fits](#Data-format-of-lsdr9_tgttype.{zsrc}fits) |  |

### The spectroscopic infomation based on the DESI legacy survey dr9  

#### redshift source (zsrc)

zsrc is a quantity that marks the source of redshift. 0 indicates photometric redshift, while values greater than or equal to 1 indicate spectroscopic redshift. 

|Abbreviation| zsrc   | spec-z fraction | comments 
|------------|--------|-----------------|---------
| PRLSdr9    |  0     | 0.00%           | pure photo-z from PRLSdr9
| sweepfile  |  1     | 1.66%           | spec-z collected by Zhou et al. 2021
| 4LRGC      |  2     | 1.71%           | spec-z from low redshift group catalogs collected by lim et al. 2017
| fuji       |  3     | 2.03%           | spec-z from formal desi spectroscopic data release, fuji (1%, EDR,  2M) 
| iron       |  4     | 7.27%           | spec-z from formal desi spectroscopic data release, iron (1/3, Y1, 10M) 
| Y3daily    |  5     | 12.19%          | spez-z from daily  data reducation of desi up to 20240409 (2/3, Y3, 20M) 
| jura       |  6     | --      | spec-z from formal desi spectroscopic data release, jura (2/3, Y3, 20M)




## SEDs 

### k-correct 

IDL code: http://kcorrect.org/

##### Data format of lsdr9_kcorr.{zsrc}.fits: 

lsdr9-mk{zsrc}.fits 

|  colname       | dtype| comments
|----------------|------|--------
|    igal        | int  | Unique ID [0-...]
| 'redshift'     |  |  
| 'kcorrect_x'   |  | kcorrect to z = 0.5, X = {g,r,z,w1,w2}. 
| 'stellarmass'  |  | $h^{-2} M_\odot $
| chi2           |  | 



### cigale 

lsdr9-mk{zsrc}.fits 

##### Data format of lsdr9_cigale.{zsrc}.fits: 

|  colname       | dtype| comments
|----------------|------|--------
|    id        | int  | Unique ID [0-...], == igal
| 'best.universe.redshift'  |   | 
| 'best.stellar.m_star'   | | Total mass of stars, unit $M_\odot$ 
| 'best.sfh.sfr'  | | Instantaneous star formation rate
| 'best.dust.luminosity'| | Estimated dust luminosity using an energy balance




<!-- ```
                       EXT-morph              PSF-morph           ALL
north_ngc     |        40,360,233             44,493,809   |    84,854,042
south_ngc     |        49,149,992             53,155,166   |   102,305,158
south_sgc     |        73,808,229             70,602,469   |   144,410,698
    total     |       163,318,454            168,251,444   |   331,569,898
```  -->

#### Data format of lsdr9_info.fits

|  colname       | dtype| comments
|----------------|------|--------
|    igal        | int  | Unique ID [0-...]
|    ...         | ...  | refer to [the Tractor Catalog Format](https://www.legacysurvey.org/dr9/catalogs/)
|   MASKBITS     |  | refer to [the DR9 bitmasks](https://www.legacysurvey.org/dr9/bitmasks/) 
|'Z_PHOT_MEDIAN' |  | refer to [the photo-z sweeps catalog](https://www.legacysurvey.org/dr10/files/#photo-z-sweeps-9-1-photo-z-sweep-brickmin-brickmax-pz-fits) of v9.0
|'Z_PHOT_STD'    |  | ...
|'Z_SPEC'        |  | ... 
|'frac_mask'     |  | True if (FRACFLUX_X < 0.5)&(FRACIN_X > 0.3)&(FRACMESKED_X < 0.4), X = G, R, Z
|'nobs_mask'     |  | = NOBS_G * 1 + NOBS_R * 10 + NOBS_Z * 100 


### Data format of lsdr9_tgttype.fits

|  colname       | dtype| comments
|----------------|------|--------
| 'igal'         |   i8 | Unique id in this catalog 
|  Ggaiar        |   f  | GAIA_PHOT_G_MEAN_MAG - 22.5 - 2.5 * log10(FLUX_R) 
|  rz            |   f  | - 2.5 * log10(FLUX_R/MW_TRANSMISSION_R) + 2.5 * log10(FLUX_Z/MW_TRANSMISSION_Z) 
|  rw1           |   f  | - 2.5 * log10(FLUX_Z/MW_TRANSMISSION_Z) + 2.5 * log10(FLUX_W1/MW_TRANSMISSION_W1) 
| 'tgttype0'     |   i4 | 0, if PSF; 1, if EXT. 
| 'tgttype1'     |   i4 | 0, star; 1, galaxy if Gaia - r > 0.6; (Hahn et al. 2023)
| 'tgttype2'     |   i4 | 0, star; 1, galaxy if z − W1 > 0.8 × (r − z) − 0.6 (Zhou et al. 2023)
| 'tgttype3'     |   i4 | == -1; Updated with spectype: 0, star; 1, galaxy; 2, QSO; (Redrock fitting results.)

### Data format of lsdr9_korr.fits

### Data format of lsdr9_cigale.fits

### Data format of lsdr9_tgttype.spec.fits

|  colname       | dtype| comments (non-DESI) | comments (DESI) | 
|----------------|------|---------------------|-----------------|
|    igal        | int  | Unique ID [0-...]   |Unique ID [0-...]
|  tgttype3      |  i4  | == 1                | -1, fill; 0, star; 1, galaxy; 2, QSO
| 'TARGETID'     |      | == -99              |
| 'OBJTYPE'      |      | == TGT              |
| 'Z'            |      |                     |
| ZERR',         |      | == 0.0001           |
|'ZWARN'         |      | == 0                |
|'SPECTYPE'      |      | == 'GALAXY'         |
|'DELTACHI2'     |      | == 1                |
|'ZCAT_NSPEC'    |      | == 1                | 

#### Data format of lsdr9_id.fits


|  colname       | dtype| comments
|----------------|------|--------
|    igal        | int  | Unique ID [0-...]
|    RELEASE     | int  | the record of processing run; A unique identifier is release,brickid,objid. 
|    BRICKID     | int  | brick ID [1,662174], encoding the brick sky position; 
|    OBJID       | int  | catalog object number within this brick; 

#### Data format of lsdr9_target.fits

|  colname       | dtype| comments
|----------------|------|--------
|    igal        | int  | Unique ID [0-...]
|    TARGETID    | int64| Unique ID of spectroscopic targets; if not DESI targets, -99. 
|    DESI_TARGET | int64| [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)
|    BGS_TARGET  | int64| [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)
|    MWS_TARGET  | int64| [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)
|    SCND_TARGET | int64| [Target masks](https://desidatamodel.readthedocs.io/en/latest/bitmasks.html#target-masks)

#### Data format of lsdr9_tile.fits

|  colname       | dtype| comments
|----------------|------|--------
|  ntile_*_fuji   | int  |  * = sv3, bright, dark, backup, other; >=1, located in fuji footprint; 0, not in.  
|  ntile_*_iron   | int  | >=1, located in iron footprint; 0, not in.  
|  ntile_*_jura   | int  | >=1, located in jura footprint; 0, not in.  
|  ntile_*_full   | int  | >=1, located in planned footprint of DESI; 0, not in.  
| |lsdr9_nspec.fits| 
|   nspec_fuji    | int  | The number of spectra observed. 
|   nspec_iron    | int  | The number of spectra observed. 
|   nspec_jura    | int  | The number of spectra observed. 
| |lsdr9_seedold.fits|
|    iseed       | int  | the id in the old version of seedcat [0,138315648]. If not, -99.  
|    iseed_psf   | int  | the PSF-type supplyments of the seed catalog, starting with 138315649.


#### Data format of lsdr9_mask.fits

|  colname       | dtype| comments
|----------------|------|--------
|    igal        | int  | Unique ID [0-...]
|  masked        |      | 0, not masked; >0, masked.

#### Data format of lsdr9_frac.fits

|  colname       | dtype| comments
|----------------|------|--------
|    igal        | int  | Unique ID [0-...]
|  FRACFLUX_X    |      | X = G, R, Z
|  FRACIN_X      |      | X = G, R, Z
|  FRACMASKED_X  |      | X = G, R, Z


#### Data format of lsdr9_usebits.fits

The description of  **usebits**: 

|   Bit Name     | bit number| Description (=0)
|----------------|-----------|------------------------------
| 'qualitycut'   |    0      |  to select FRACFLUX_X < 0.5, FRACIN_X > 0.3, FRACMASKED_X < 0.4, for all X = {g, r, z}
| 'maskbits'     |    1      |  to reject bits of MASKBIT 1,5,6,7,8,9,11,12,13
| 'bizarrecolor' |    2      |  to select (−1 < g − r < 4)&(−1 < r − z < 4)
| 'redshift'     |    3      |  to select (FLUX_X > 0, for all X = {g, r, z, w1, w2})  
| 'foreground'   |    4      |  Not masked by bright star, median star, Globular Clusters, Planetary Nebulae, and local large galaxies. 
