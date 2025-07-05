

asfunc_ang2pix  data.fits -o hppix.fits --nside 16
asfunc_ang2mask data.fits mask.fits -o data-mask.fits 
asfunc_ang2tile data.fits tile.fits -o data-tile.fits 
asfunc_ang2map  data.fits  -o hpmap.fits
asfunc_map2ang  hpmap.fits -o rand.fits  -d 1000
