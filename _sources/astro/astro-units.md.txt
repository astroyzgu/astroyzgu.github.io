# 单位转化

###### flux & magnitude (AB星等，ST星等，VEGA星等) 

The zero points are defined to coincide with the zero point of the widely
used “visual” or standard “broad-band” V magnitude system: 

$m_\lambda (5500Å) = m_\nu (5500 Å) = V = 0$

| magnitude of  V “broad-band”   |flux of V “broad-band”| Definition |
|--------|------|-|
| $Mag_{ST} = m_\lambda(5500 Å) = 0$ |$f_{\lambda} = 3.631×10^{−11} ergs\ s^{−1}  Å^{−1} cm^{−2} $  | $m_\lambda(\lambda) = -2.5 \times log(F_\lambda) - 21.1 $ |
| $Mag_{AB} = m_\nu (5500 Å) = 0$ |$f_\nu= 3.636×10^{−20} ergs\ s^{−1}  Hz^{−1} cm^{−2}$ | $m_\nu (\nu) = -2.5 \times log(F_\nu) - 48.6 $ | 


| unit | convertion formular of AB magnitude|        comments | 
|------|------------------------------------|-----------------------------------| 
| 1 $ergs\ s^{−1}  Hz^{−1} cm^{−2}$ | $m_\nu (\nu) = -2.5 \times log(F_\nu) - 48.6 $| 
| 1 $Jy$ | $m_\nu (\nu) = -2.5 \times log(F_\nu) + 8.9 $ | ${1 Jy = 10^{-23} ergs\ s^{-1} cm^{-2} Hz^{-1} }$   
| $3.636×10^{−30} ergs\ s^{−1}  Hz^{−1} cm^{−2}$ | $m_\nu = -2.5 \times log(F) + 25 $



###### SkyCoord (equator, galactic and ecliptic)   

```
from astropy import units as u
from astropy.coordinates import SkyCoord

ra   = [112.357708,122.580465,104.726966] 
dec  = [-12.69596,-5.513852,-10.580455]

equator  = SkyCoord(ra=ra*u.degree, dec=dec*u.degree, frame='icrs')

l_ecliptic   = equator.geocentricmeanecliptic.lon.degree
b_ecliptic   = equator.geocentricmeanecliptic.lat.degree

ra    = equator.icrs.ra.degree
dec   = equator.icrs.dec.degree

l_galactic  = equator.galactic.l.deg
b_galactic  = equator.galactic.b.deg


def equ2ecl(a, d, e = 23.43333): 
    '''
    equator  to ecliptic 
    e = 23°26' = 23.4333 deg
    https://en.wikipedia.org/wiki/Ecliptic_coordinate_system 
    '''
    from numpy import cos, sin, arctan2, arcsin
    a = np.atleast_1d(a)*np.pi/180
    d = np.atleast_1d(d)*np.pi/180
    e = e*np.pi/180 
    sinb = cos(e)*sin(d)-sin(e)*cos(d)*sin(a) # sinβ 
    cosbcosl = cos(d)*cos(a)                  # cosβ*cosλ
    cosbsinl = sin(d)*sin(e)+cos(d)*cos(e)*sin(a) # cosβ*sinλ
    b = arcsin(sinb)/np.pi*180 
    #print(arctan2(np.sqrt(3),1)/np.pi*180 )
    l = arctan2(cosbsinl, cosbcosl)/np.pi*180.0
    #l = l - (np.ceil(l/360.0)-1)*360.0
    return l, b
```
