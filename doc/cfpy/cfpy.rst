python c fortran 混合编程
========================

quickstart 
^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 1

   basic_f.md
   basic_py.rst 
   plot2d_py.md 
   basic_parallel.md  
   basic_largearray.md
   python-sphinx.rst 
   usage-github.md

setuptools统一 
^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 2

   usage_setuptools.md

.. code-block:: shell

	# 添加路径
	export PYTHONPATH=$PYTHONPATH:$(pwd)
	export LIBRARY_PATH=$LIBRARY_PATH:$(pwd)
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)
	export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$(pwd)



python call f 
^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 2

   python_call_f.md

python call c
^^^^^^^^^^^^^

.. toctree::
   :maxdepth: 2

   python_call_c.md

f call python 
^^^^^^^^^^^^^
.. toctree::
   :maxdepth: 2

   f_call_python.md

python tricks 
^^^^^^^^^^^^

.. toctree::
   :maxdepth: 2

   python_decorator.md
   trick_py.md 
