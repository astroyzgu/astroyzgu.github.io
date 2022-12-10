asfunc-demo.main_block 
===========

| The demostration of the main block. This code is still in compiling. 
| Any problem or suggestion is welcome! (e-mail: guyizhou@sjtu.edu.cn). 

Quick start
^^^^^^^^^^

- main_block.assign2pix 
- main_block.assign2wht 
- main_block.save_weight (load_weight) 
- main_block.save_boundary (load_boundary)

- plot_block.cyl (or plot_block.moll) 
  - m.set_parallels(), m.set_meridians()
  - m.set_galactic(b0 = 0, color = 'k', lw = 2, ls = 'dashed')
  - m.set_gc()
  - m.fill_boundary(nside, ipix, wht = None) 
     - cmap 
     - facecolor, edgecolor  
  - m.scatter()  # same as matplotlib Axes().plot()
  - m.plot()     # same as matplotlib Axes().plot()
  - m.text()     # same as matplotlib Axes().text()
  - m.多边形 ??  
