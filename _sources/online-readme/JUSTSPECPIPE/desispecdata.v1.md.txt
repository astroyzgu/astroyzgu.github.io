# raw data from DESI DR1 

### data 

| PATH                     | FILENAME                                                                                |
|--------------------------|-------------------------------------------------------------------------------------------------|
| data/20210610/00093094/  | [desi-00093094.fits](https://cdn.processon.com/67adeacae4b038d705058138?e=1739454682&token=trhI0BY8QfVrIGn9nENop6JAc6l5nZuxhjQ62UfM:nAz3lW1ukr9QiBYDL0DKVAammME=]) <br>fibermap-00093262.fits                                                   |
| calibnight/20210610/      | badcolumns-z9-20210610.csv<br>biasnight-z9-20210610.fits.gz<br>psfnight-z9-20210610.fits<br>fiberflatnight-z9-20210610.fits |  
| preproc/20210610/00093094/    | fibermap-00093262.fits<br>preproc-z9-00093262.fits                                             | 
| exposures/20210610/00093094/  | stdstar-9-00093262.fits<br>psf-z9-00093262.fits <- same as psfnight-z9-20210610.fits <br>traceshift-<br>frame-z9-00093262.fits<br>fiberfaltexp-z9-00093262.fits <- same as fiberflatnight-z9-20210610.fits  <br>sky-z9-00093262.fits<br>sframe-z9-00093262.fits<br>fluxcalib-z9-00093262.fits<br>cframe-z9-00093262.fits | |
| placeholder to 1D files |  coadd-main-dark...fits<br>emline-main-dark...fits<br>hpixmap-main-dark...fits<br>qso_mgii-main-dark...fits<br>qso_qn-main-dark-...fits<br>redrock-main-dark...fits<br>rrdetails-main-dark...fits<br>spectra-main-dark...fits


<!-- blanksky map<br>standard star catalog<br>A table including all the objects can be reached<br>FLUX 2d<br>IVAR 2d<br>MASK 2d<br>READNOSIE 2d<br>FIBERMAP                                                                                                                                                                                                                                                                                                                                                                        | --
<!-- the normalized standard star models fitted to the frame data.<br>PSF (point spread function) files model the mapping of fibers and wavelengths to pixels on spectrograph CCDs.<br>Input PSF with spectral trace coordinates and wavelength calibration adjusted to the current CCD image, used as a starting guess for the PSF shape fit.<br>Frame files contain the raw extracted electrons from DESI data, without any further calibration.<br>fiberflat to use for a specific exposure such that newflux = rawflux/fiberflat.<br>the sky model for a given camera and exposure.<br>fiber-flatfielded and sky-subtracted but not flux calibrated per-camera spectra.<br>flux calibration model for a given camera and exposure.<br>The calibrated spectra for a given camera and exposure.  -->

### step by step 
#### preproc 
#### 
