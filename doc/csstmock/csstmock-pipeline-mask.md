# mask 

###### survey mask 

###### foreground mask 

* LS DR9 masking: [https://www.legacysurvey.org/dr9/external/#external-catalogs-used-for-masking]()
* HSC-dr2 masking: [https://hsc-release.mtk.nao.ac.jp/doc/index.php/bright-star-masks-2/]()
* MASKING applying on DESI
  - Hahn et al. 2023; 
  - Zhou et al. 2023; 
  - Kitanidis et al. 2020;  
  - Ruiz-Macias et al. 2021
``` python
vetomap, nside = skycov_healpy('lsdr9-ngc') 
pixarea    = hp.nside2degree(nside, degrees = True) 
agal, dgal = rand_rectangle(nrand, ramin, ramax, decmin, decmax)
agal, dgal = rand_in_pix(nside, pix, nrand) 
indx       = ellipse_masking(agal, dgal, u, v, a, pa, ba)
maskcov    = np.sum(indx)/nrand*pixarea*len(pix) 
``` 

``` python
def fracndim(lists, bins = None, mask = None):
    '''
    outershape: 循环层数和每层的次数
    '''
    if bin_list is None: 
        return np.sum(mask)/np.prod(np.shape(mask))
    
    if isinstance(data, list): data = np.array(data).T
    
    outershape = [len(bins)-1 for bins in bin_list] 
    for iloop, d in enumerate(outershape): 
        if d == -1: 
            bin_new = np.sort( np.unique(data[:,iloop])  )
            bin_list[iloop]  = np.append(bin_new, bin_new[-1]+1) 
            
    hist2, edges = np.histogramdd(data, bins=bin_list)
    if mask is not None: hist1, edges = np.histogramdd(data[mask,:], bins=edges)
    if mask is not None: 
        fracndim = 1.0*hist1/hist2
    else: 
        fracndim = 1.0*hist2
    return fracndim, edges
```


``` python
    def sphrand_uniform(nrand, ramin, ramax, decmin, decmax): 
        """
	Draw a random sample with uniform distribution on a sphere

        Parameters
        ----------
        nrand : int
            the number of the random points to return
        ramin, ramax: float
            Right Ascension between ramin and ramax [degrees] 
        decmin, decmax: float 
            Declination between decmin and decmax [degrees]
        Returns
        -------
        ra, dec : ndarray
            the random sample on the sphere within the given limits.
            arrays have shape equal to nrand.
	skycov: float 
	    sky coverage [deg^2].
        """
        zmax = np.sin( np.asarray(decmax) * np.pi * / 180.)
        zmin = np.sin( np.asarray(decmin) * np.pi * / 180.)

        z   = zmin + (zmax - zmin) * np.random.uniform(0, 1, nrand)
        DEC = (180. / np.pi) * np.arcsin(z)
        RA  = ramin +  (ramax - ramin) * np.random.uniform(0, 1, nrand)

	skycov = (zmax - zmin)*180/np.pi *(ramax - ramin)
        return RA, DEC, skycov 
```



``` python
def rand_vec_in_pix(nside, ipix, nest=False):
    """
    Draw vectors from a uniform distribution within a HEALpixel.

    :param nside: nside of the healpy pixelization
    :param ipix: pixel number(s)
    :param nest: set True in case you work with healpy's nested scheme
    :return: vectors containing events from the pixel(s) specified in ipix
    """
    if not nest:
        ipix = hp.ring2nest(nside, ipix=ipix)

    n_order = nside2norder(nside)
    n_up = 29 - n_order
    i_up = ipix * 4 ** n_up
    i_up += np.random.randint(0, 4 ** n_up, size=np.size(ipix))

    v = pix2vec(nside=2 ** 29, ipix=i_up, nest=True)
    return np.array(v)
``` 

``` python
def skycov_healpy(surveyname):  
    ''' 
    Return the vetomap and nside of preset healpy pixelization of some given surveys.

    parameters
    ----------
    surveyname: str 
	name of preset survey, 'desidr9', 'hscdr3', 'csstv0'
	- surveyname == 'desidr9':   18350.26 deg^2, nside = 256, (pixarea = 5.246e-02 deg^2/pixel) 
	- surveyname == 'lsdr9-ngc': , nside = 256, (pixarea = 5.246e-02 deg^2/pixel) 
	- surveyname ==  'hscdr3':   967.39 deg^2, nside = 512, (pixarea = 1.311e-02 deg^2/pixel)
	- surveyname == 'csstv0':  16787.94 deg^2, nside = 512  (pixarea = 1.311e-02 deg^2/pixel)  
    Returns
    -------
    vetomap: ndarray
	 An array with size = 12*nside*nside. 1.0 means w/i survey; 0.0 means w/o survey.  
    nside: int 
         nside of the healpy pixelization
    ''' 
```

``` python
def ellipse_masking(ra, dec, u, v, a, pa, ba):  
    ''' 
    Returns a boolean array of the same shape as ra that is True where the position 
(ra, dec) is in the ellipse shape. 

    parameters
    ----------
    ra, dec:  float, scalars or array-like
	Angular coordinates of input targets on the sphere
    u, v: float, scalars or array-like
	Angular coordinates of central point of ellipse on the sphere
    a: float, scalars or array-like
	The length of Semi-major axis of ellipse [degree] 
    pa:  float, scalars or array-like
	Position angle [degree]. PA == 0 is North (ΔDEC>0), PA = 90 is WEST (ΔRA > 0). 
    ba:  float, scalars or array-like
	b/a [0,1]. if ba == 1, the shape is circle, namely the cap on the sphere. 
    Returns
    -------
    vetomap: ndarray
	 An array with size = 12*nside*nside. 1.0 means w/i survey; 0.0 means w/o survey.  
    nside: int 
         nside of the healpy pixelization
    ''' 
```

 

###### 
``` python 
def atleast_1d(*arys):
    """
    Convert inputs to arrays with at least one dimension.
    Scalar inputs are converted to 1-dimensional arrays, whilst
    higher-dimensional inputs are preserved.
    Parameters
    ----------
    arys1, arys2, ... : array_like
        One or more input arrays.
    Returns
    -------
    ret : ndarray
        An array, or list of arrays, each with ``a.ndim >= 1``.
        Copies are made only if necessary.
    See Also
    --------
    atleast_2d, atleast_3d
    Examples
    --------
    >>> np.atleast_1d(1.0)
    array([ 1.])
    >>> x = np.arange(9.0).reshape(3,3)
    >>> np.atleast_1d(x)
    array([[ 0.,  1.,  2.],
           [ 3.,  4.,  5.],
           [ 6.,  7.,  8.]])
    >>> np.atleast_1d(x) is x
    True
    >>> np.atleast_1d(1, [3, 4])
    [array([1]), array([3, 4])]
    """
    res = []
    for ary in arys:
        ary = asanyarray(ary)
        if ary.ndim == 0:
            result = ary.reshape(1)
        else:
            result = ary
        res.append(result)
    if len(res) == 1:
        return res[0]
    else:
        return res
```
