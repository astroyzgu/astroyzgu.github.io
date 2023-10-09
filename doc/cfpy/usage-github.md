# git入门

## [入门笔记] Github - 基于git的代码托管平台

[参考网页] https://zhuanlan.zhihu.com/p/437280775 

###### 注册和连接设置
``` bash 
# 1. 网页注册[Username，e-mail, password]

# 2. Github连接设置

#--- 2.1 本地设置 
ssh-keygen -t rsa -C "你的注册邮箱" # 在本地创建ssh key 
vi ~/.ssh/id_rsa.pub # 复制里面的key

#--- 2.2 网页端设置 
打开网页登陆-> 右上角头像下拉-> settings SSH and GP Gkeys -> SSH keys 
将复制好的key添加进去，title自便

#--- 2.3 连接github
ssh -T git@github.com 

#--- 2.4 设置用于登陆远端服务器的邮箱和用户名
git config --global user.name "你的用户名"
git config --global user.email "你的注册邮箱"

# 3. 日常更新和推送
cd  respository-test 
git status    # 检查仓库的状态, helloworld.txt没有被提交（红色的）
git add -A    # 添加此目录下所有文到缓存区（注意此时还没有实际改动）
git commit -m # 将改动提交到Head(此时仅在本地做了实际改动，远端仓库并没有影响)
git push      # 推送到远端 

```

###### 本地仓库和远端服务器仓库的创建、管理和相互推送

1. 创建仓库
``` bash 
# 远端服务器仓库(respository)创建

在网页上创建 create a new respository -> respository-test

# 本地仓库(respository)创建和复制

mkdir respository-test; cd respository-test/  # 创建并进入本地文件夹
git init                                      # 初始化一个空的本地仓
git status                                    # 检查仓库的状态

# 也可以直接复制远端服务器上的仓库

git clone git@github.com:astroyzgu/guyzastro-web.git 
``` 

2. 创建和更新文件 
```
# git维护的三棵"树"
#
# working dir  - 工作目录，它持有实际文件
# Index        - 缓存区域，临时保存你的改动
# Head         - 指向最后一次提交的结果 
#------------------------------------------------------------------------------
# 随意创建一个文件, 并最后提交, 设立分支branch1 
echo "h" > helloworld.txt                     # 随意创建一个文件  
git add helloworld.txt                        # 添加到缓存区
git commit -m 'change to: h '                 # 提交到Head
git branch branch1                            # 标记一个分支点branch1, -d为删除

# 随意修改一个文件, 并最后提交, 设立分支branch2 
echo "hello" > helloworld.txt                 # 随意修改一个文件  
git add helloworld.txt                        # 添加到缓存区
git commit -m 'change to: hello'              # 提交到Head
git branch branch2                            # 标记一个分支点branch2, -d为删除

# 再次随意修改一个文件, 并最后提交，默认分支名为master 
echo "hello world" > helloworld.txt           # 随意修改一个文件  
git add helloworld.txt                        # 添加到缓存区
git commit -m 'change to: hello world'        # 提交到Head
```

3. 推送到远端服务器
``` bash
# 连接远端服务器，推送当前分支到远端服务器
git remote add origin git@github.com:astroyzgu/respository-test.git
git push -u origin master   # 将master 推送到远端仓库 
git push -u origin branch2  # 将branch2推送到远端仓库 
git push origin -d branch2  # 将远端仓库中的branch2删除 

git branch -a          # 查看所有分支, 标*为当前所在分支
git checkout <branch>  # 切换到<branch>这个分支



                                       ↗----> origin/Master [远程仓库]
                                      ↗ 
       ↗----> branch 1               ↗ push 
      ↗                             ↗                
----> modify 1 ----> modify 2 ----> modify 3 → branch Master [本地默认仓库] 
      h              hello        hello world 
                     ↘                  
                      ↘----> branch 2
``` 


## [部署网页] Github - 部署个人网页 

[Deploying Sphinx documentation to GitHub Pages](https://coderefinery.github.io/documentation/gh_workflow/) 
* Serve websites from a GitHub repository, named `https://myuser.github.io/myproject`. 

###### 大致步骤  

* 编辑` .github/workflows/documentation.yml`
  - 主要关注`steps:`下面的内容，即在每一次推送后会执行的步骤。 

* 网页端设置
  - 打开仓库-> settings -> pages 
  - Build and deployment (构建和部署) 
  - source (选择源) -> Deploy from a branch (从一个分支部署)
  - Branch (选择分支) -> gh-pages (预览网页的分支) 








