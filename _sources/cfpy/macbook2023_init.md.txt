# INSTALL (macbook pro 2003 macOS Sonoma 14.0) 

#### 基本软件

apple store: 微信, QQ，office365, 


XQuartz:  https://www.xquartz.org/index.html

Clashx: https://clashx.org/clashx-official/ 

#### Teriminal 

###### 更改默认的Shell为Bash 

```
echo $SHELL       # 查看当前默认的Shell
chsh -s /bin/bash # 更改默认的Shell为Bash
```

或在系统设置中设置

```
"系统设置" > "用户与群组" > "高级选项" > "登录 shell" > "/bin/bash"
```

###### .vimrc

```
set guifont=Menlo\ Regular:h20
```

###### conda

* website 

instal miniconda3: https://docs.conda.io/projects/miniconda/en/latest/


```
conda upgrade --all
conda install mamba -c conda-forge
conda config --set auto_activate_base false 
```

```
mamba install -c conda-forge astropy matplotlib healpy ipykernel tqdm cffi pandas scikit-learn ipykernel h5py imageio
```

* bug 

**Report**: ...Library not loaded: @rpath/libarchive.13.dylib

```
# Mac找不到libarchive库，使用 Homebrew 安装后再链接过去
brew install libarchive
brew list libarchive 
ln -s /opt/homebrew/Cellar/libarchive/3.7.2/lib/libarchive.13.dylib /Users/${USER}/miniconda3/lib/
```

###### homebrew 

* website  

[Homebrew](https://brew.sh/) 
[online package browser for homebrew](https://formulae.brew.sh/)
[!!!使用科大源安装Homebrew](https://mirrors.ustc.edu.cn/help/brew.git.html#homebrew-linuxbrew)
[!!!Homebrew使用详解](https://zhuanlan.zhihu.com/p/30704752)

* install 

```
# Install Homebrew and  Command Line Tools for Xcode  
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

* usage

```
# 「Formulae」一般是那些命令行工具、开发库、字体、插件等不含 GUI 界面的软件
brew install wget 
brew install md5sha1sum # echo -n "helloworld" | sha1sum  (sha1 hash linux) 
brew install cmake

# 「Cask」是指那些含有 GUI 图形化界面的软件
brew install --cask visual-studio-code
```

###### git 


* bug 

```
# fatal: unable to access '...': Recv failure Connection was reset
git config --global --unset http.proxy 
git config --global --unset https.proxy
```

###### python install

###### 

# Soft

#### FAST++

#### EAZY 

#### SED/spec fitting 
 
- 
