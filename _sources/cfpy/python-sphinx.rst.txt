python-sphinx 记录
====================

- https://coderefinery.github.io/documentation/gh_workflow/

- Installation and usage records of python-sphinx; `Usage link <https://zh-sphinx-doc.readthedocs.io/en/latest/contents.html>`_


安装sphinx和插件
^^^^^^^^^^^^^^^^^^^^


| ``pip install sphinx``
| ``pip install jieba3k # 支持中文``
| ``pip install sphinx_rtd_theme # 安装主题``
| ``pip install recommonmark # 支持markdown``
| ``pip install sphinx-markdown-tables #  支持markdown table``
| ``pip install myst_parser``
| ``pip install sphinx-autobuild``
| ``pip install sphinx_math_dollar``
 

 Document: https://myst-parser.readthedocs.io/en/latest/syntax/syntax.html

使用
^^^^^^^^

快速入门和配置
--------------

1. 建立放置文档的文件夹 

   ``mkdir doc; cd doc``


#. 初始化 ./sphinx-quickstart

   .. code-block:: 

      > 独立的源文件和构建目录（y/n） [n]: y 
      > 项目名称: yzastro
      > 作者名称: Gu Yizhou
      > 项目发行版本 []: 1.0.0
      > 项目语种 [en]: en


#. 修改source/conf.py 

   + 添加到python的搜索路径（在第13-16行）

   .. code-block:: 

      import os
      import sys
      sys.path.insert(0, os.path.abspath('../../yzastro'))

   + 加载扩展插件

   .. code-block:: 

      extensions = [
      'sphinx.ext.autodoc',
      'sphinx.ext.napoleon',
      'sphinx.ext.viewcode',]

   + 修改主题 

   .. code-block:: 

      html_theme = 'sphinx_rtd_theme'

#. 修改source/index.rst [与显示有关]

   参考 RST文件_ 和其他已有包的文档。


#. 更新文档 update.sh

   每当代码更新时， 执行如下更新说明文档。

   .. code-block::  

      make clean
      sphinx-apidoc -o source ../yzastro -f
      make html
      open build/html/index.html 

RST文件
---------
可以将 RST 文件理解为 Python 使用的 Markup 文件。

- Sphinx 使用手册, RESTRUCTUREDTEXT(rst)简介: https://zh-sphinx-doc.readthedocs.io/en/latest/rest.html 
- 官方的使用手册，请参考链接：https://docutils.sourceforge.io/docs/user/rst/quickstart.html
- 目前还有一个在线的编辑环境，请参考http://rst.ninjs.org/#Kml0YWxpY3Mq上面的内。你可以在上面的链接中对标记文件进行编辑。
- 简书中文版快速入门： https://www.jianshu.com/p/1885d5570b37
- 在编辑的过程中，你可能还需要对 Markup 的语法有所了解。https://www.ossez.com/t/python-rst/177
- https://blog.csdn.net/qq_32460819/article/details/121116837 

demo
---------

- 写法一 demo1.py

   .. code-block::  python 

      #coding=UTF-8
      class Demo1():
         """类的功能说明"""

         def add(self,a,b):
             """两个数字相加，并返回结果"""
             return a+b

         def google_style(arg1, arg2):
             """函数功能.

             函数功能说明.

             Args:
                 arg1 (int): arg1的参数说明
                 arg2 (str): arg2的参数说明

             Returns:
                 bool: 返回值说明

             """
             return True

         def numpy_style(arg1, arg2):
             """函数功能.

             函数功能说明.

             Parameters
             ----------
             arg1 : int
                 arg1的参数说明
             arg2 : str
                 arg2的参数说明

             Returns
             -------
             bool
                 返回值说明

             Examples
             --------
             >>> np.atleast_1d(1.0)
             array([ 1.])
             >>> x = np.arange(9.0).reshape(3,3)


             """
             return True

   .. automodule:: test.demo1
      :members:
      :undoc-members:
      :show-inheritance:

- 写法二 demo2.py
   .. code-block::  python 

      #coding=UTF-8
     
      def my_function(a, b):
         """函数功能说明
     
          >>> my_function(2, 3)
          6
          >>> my_function('a', 3)
          'aaa'
     
         """
         return a * b

   .. automodule:: test.demo2
      :members:
      :undoc-members:
      :show-inheritance:

     
- 写法三demo3.py (from numpy.atleast1d ) 
   .. code-block::  python 


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


   .. automodule:: test.demo3
      :members:
      :undoc-members:
      :show-inheritance:
 
