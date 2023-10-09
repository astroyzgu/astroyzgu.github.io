python安装和基础 
==========

 https://astro-330.github.io/intro.html 


安装anaconda
^^^^^^^^^^^^^^

个人电脑: https://www.anaconda.com/, 安装anaconda

服务器上: ``module load anaconda/anaconda-mamba``, 载入anaconda 

搭建python环境
^^^^^^^^^^^^^^

.. code-block:: shell

   # 
   # 在gravity login02上 
   # 

   module load anaconda/anaconda-mamba
   
   #
   # 搭建python环境
   # 
   conda create -n py39 python=3.9 anaconda # 创建新环境, python-3.9.7
   source activate py39 # 激活py3环境
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge
   conda install mamba -c conda-forge # 安装mamba用c++重写了部分解析过程, 可代替conda命令

   #
   # 安装软件
   # 

   mamba install astropy matplotlib healpy ipykernel tqdm # 依赖性安装numpy cfitsio scipy
   mamba install mpi4py cffi pandas scikit-learn ipykernel h5py 
   mamba install basemap pymangle 
   mamba install psutil imageio opencv-python
 
   conda install -c conda-forge opencv

   #
   # 将环境部署到到Jupyter Notebook上
   # 

   mamba install ipykernel # 安装并注册为 ``jupter kernel``, 可以 
   python -m ipykernel install --user --name py3 --display-name "py3-env"

其他命令 
^^^^^^^^^^^^^^

.. code-block:: shell

   conda create -n envB --clone envA # 复制环境envA为新环境envB
   conda环境路径在/anaconda3/envs/环境1  # 把A机器整个环境1拷贝下来复制到B机器的任意地方
   conda create -n 环境2 --clone 复制的环境1的路径 # 在B机器上复制生成新的环境

   python -m ipykernel install --user --name py39 --display-name "py39"  # ipykernel生成虚拟环境的kernel
   jupyter kernelspec list # 安装的kernel的内核和位置 
   jupyter kernelspec remove py39 # 删除某一个kernel，如py39

   conda env list # 列出所有环境
   conda remove -n py39 --all # 删除py39环境
   conda config --set show_channel_urls yes # 显示告诉我们当前下载源的出处
   conda config --set channel_priority strict # 考虑最高优先级的channel 
   conda upgrade --all

   # 其他的源   
   conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
   conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/

   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/conda-forge/
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/msys2/
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/bioconda/
   conda config --add channels https://mirrors.ustc.edu.cn/anaconda/cloud/menpo/

   conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/main/
   conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/pkgs/free/
   conda config --add channels https://mirrors.sjtug.sjtu.edu.cn/anaconda/cloud/conda-forge/

为深度学习搭建一个环境
^^^^^^^^^^^^^^^

新建环境（或使用已有环境）:


.. code-block:: shell

   conda activate tf2
   conda install mamba -c conda-forge
   mamba install tensorflow-gpu  cudatoolkit tqdm imageio healpy ipykernel 
   python -m ipykernel install --user --name tf2  # 安装并注册为 ``jupter kernel`` , 然后可以在Jupyter中选择名为tf2环境的Kernel进行计算。


   # 如果环境需要依赖NVIDIA CUDA Toolkit或NVIDIA cuDNN，可以使用conda进行安装：
   conda install tensorflow_gpu=2.6
   # ``conda install cudatoolkit=10.1 cudnn``


   # 配置tensorflow_gpu=v2.6的环境
   conda remove -n tf2 --all # 删除已有的环境
   jupyter kernelspec list # 查看所有已经安装的kernel 
   jupyter kernelspec remove tf2 
   #---------------
   conda create -n tf2 python=3.7 anaconda # (支持2.7.*, 3.6.*和3.7.*)
   module load anaconda/anaconda-mamba
   conda activate tf2
   conda install numpy, pandas, matplotlib, astropy
   conda install tensorflow_gpu=2.6

https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
https://docs.anaconda.com/anaconda/user-guide/tasks/tensorflow/


windows11+WSL+Xming
^^^^^^^^^^^^^^^

.. code-block:: shell

   # 检查xming是否正常运行 
   export DISPLAY=192.168.0.21:0.0 # 主机的ip地址加display number
   xeyes 

   # 检测英伟达驱动和显卡是否安装成功 
   nvidia-smi 

 

notebook插件
^^^^^^^^^^^^^^^

.. code-block:: shell 
   pip install jupyter_contrib_nbextensions && jupyter contrib nbextension install

   # 1 Table of Contents：更容易导航
   # 2 Autopep8：轻轻一击就能获得简洁代码
   # 3 variable inspector：跟踪你的工作空间
   # 4 ExecuteTime：显示单元格的运行时间和耗时
   # 5 隐藏代码输入：隐藏过程，展示结果

matplotlib 默认参数配置
^^^^^^^^^^^^^^^
.. code-block:: python 

    # 寻找当前环境下配置文件位置
    >>> python
    >>> import matplotlib
    >>> print(matplotlib.matplotlib_fname())
    /opt/anaconda2/envs/py37/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc
    
    # 修改文件中的参数
    
    font.family         : Times
    font.size           : 14.0
    font.serif          : Times New roman
    font.sans-serif     : Times New roman
    text.usetex         : False
    mathtext.cal : cursive
    mathtext.rm  : sans
    mathtext.tt  : monospace
    mathtext.it  : sans:italic
    mathtext.bf  : sans:bold
    mathtext.sf  : sans
    mathtext.fontset : custom
    
    xtick.top            : True  ## draw ticks on the top side
    xtick.bottom         : True   ## draw ticks on the bottom side
    xtick.direction      : in    ## direction: in, out, or inout
    xtick.minor.visible  : True  ## visibility of minor ticks on x-axis
    ytick.left           : True   ## draw ticks on the left side
    ytick.right          : True  ## draw ticks on the right side
    ytick.direction      : in    ## direction: in, out, or inout
    ytick.minor.visible  : True  ## visibility of minor ticks on y-axis


ADS的使用 (https://ui.adsabs.harvard.edu/)
^^^^^^^^^^
.. images:: images/ADS_overview_fig01.png
.. images:: images/ADS_overview_fig02.png 

python plot
^^^^^^^^^^



debug 
^^^^^^^^^^

.. code-block:: 
	
	'''
	jupyter-lab 
	
	...
	...

	ValueError: current limit exceeds maximum limit
	提高上限就好啦
	'''	
	ulimit -n # >>> 2048 
	sudo launchctl limit maxfiles 65535 65535
