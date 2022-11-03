python安装和基础 
==========

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

   mamba install astropy matplotlib healpy ipykernel # 依赖性安装numpy cfitsio scipy
   mamba install mpi4py cffi pandas scikit-learn ipykernel h5py 
   mamba install basemap pymangle 
   mamba install psutil imageio opencv-python 

   #
   # 将环境部署到到Jupyter Notebook上
   # 

   mamba install ipykernel # 安装并注册为 ``jupter kernel``, 可以 
   python -m ipykernel install --user --name py3 --display-name "py3-env"

其他命令 
^^^^^^^^^^^^^^

.. code-block:: shell

   python -m ipykernel install --user --name py39 --display-name "py39"  # ipykernel生成虚拟环境的kernel
   jupyter kernelspec list # 安装的kernel的内核和位置 
   jupyter kernelspec remove py39 # 删除某一个kernel，如py39

   conda env list # 列出所有环境
   conda remove -n py39 --all # 删除py39环境
   conda config --set show_channel_urls yes # 显示告诉我们当前下载源的出处
   conda config --set channel_priority strict # 考虑最高优先级的channel 

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

   mamba install tensorflow_gpu=2.6  cudatoolkit=10.1
   conda upgrade --all
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
   python -m ipykernel install --user --name tf2  # 安装并注册为 ``jupter kernel`` , 然后可以在Jupyter中选择名为tf2环境的Kernel进行计算。

https://docs.conda.io/projects/conda/en/latest/user-guide/tasks/manage-pkgs.html
https://docs.anaconda.com/anaconda/user-guide/tasks/tensorflow/

