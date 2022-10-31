# 装饰器 @classmethod和@staticmethod

###### @classmethod的作用

参考： 

[python中的@classmethod](https://blog.csdn.net/weixin_48580001/article/details/115220956)

[为什么 classmethod 比 staticmethod 更受宠?](https://blog.csdn.net/somenzz/article/details/122183550)


```
class Data_test2(object):
    day=0
    month=0
    year=0
    def __init__(self,year=0,month=0,day=0):
        self.day=day
        self.month=month
        self.year=year
    @classmethod
    def get_strdate(cls,data_as_string):
        #这里第一个参数是cls， 表示调用当前的类名
        year,month,day=map(int,data_as_string.split('-')) # 数据的预处理 
        date1 = cls(year,month,day)  
        return date1               #返回的是一个初始化后的类

    @classmethod
    def get_ymddate(cls, y,m,d):
        year,month,day= map(int, [y,m,d]) # 数据的预处理 
        return cls(year,month,day) # 返回的是一个初始化后的类  
 
    def out_date(self):
        print("year :",self.year)
        print("month :",self.month)
        print("day :",self.day)
# @classmethod
# 不需要实例化, 即先执行Data_test2 = Data_test2()
# 可以直接通过类名.方法名()调用 
# **关键** classmethod 可以为一个类准备多种预处理的方法。 
r=Data_test2.get_strdate("2020-1-1")  # 可以以字符串初始化
r=Data_test2.get_ymddate("2020", 1, 1.0) # 也可以以三个输入初始化 
r.out_date()
``` 

感觉 classmethod 比 staticmethod 用途更广， staticmethod能做的classmethod也能实现

``` python 
import math 
class Pizza(object):
    def __init__(self, radius, height):
        self.radius = radius
        self.height = height
        print('Initialized')
        print('radius = %s'% radius) 
        print('height = %s'% height) 

    #!<-- 普通方法  
    def compute_area0(self): # 要单独实现计算圆面积还得在外面重新写一个函数
        return math.pi * (self.radius ** 2)
    def compute_volume0(self):
        return self.height*self.compute_area0() 
    # -->!


    #@staticmethod, 不需要self和cls, 跟函数的定义方式一样 
    # 跟类有关系的功能, 但在运行时又不需要实例和类参与。 
    # 计算圆面积的功能在圆柱的体积计算功能内，但是在外部也需要计算圆面积的功能
    # 又不想在外部定义重新定义一个计算圆面积函数，可以用静态方法定义。  
    # 静态方法就是类对外部函数的封装，有助于优化代码结构和提高程序的可读性。
    @staticmethod
    def compute_area1(radius): # Pizza.compute_area1(1)能作为与类无关的函数使用。 
        return math.pi * (radius ** 2)
    def compute_volume1(self):
        return self.height* self.compute_area1(self.radius) 

    @classmethod  # 不需要表示自身对象的self, 但需要表示自身类的cls参数
    def compute_area2(cls, radius): 
        return math.pi * (radius ** 2)
    def compute_volume2(cls):
        return cls.height* cls.compute_area2(cls.radius)   

    @classmethod 
    def compute_volume3(cls, height, radius):
        print(height* cls.compute_area2(radius) )  
        return cls(height, radius) 


#--------- 实例调用　
P = Pizza(1, 2) # 实例化
print( P.compute_volume0(),  P.compute_area0 ) # compute_area0(self)
print( P.compute_volume1(),  P.compute_area1 ) # compute_area1(radius)
print( P.compute_volume0(),  P.compute_area2 ) # compute_area2(cls, radius)

#---------   类调用，直接计算圆面积的功能！  
# classmethod和staticmethod定义方式不同。 
# 使用时都不需要实例化，可以直接以函数的形式调用。 
print( Pizza.compute_area1(1), Pizza, Pizza.compute_area1 ) 
print( Pizza.compute_area2(1), Pizza, Pizza.compute_area2 ) # 不和实例绑定是函数，和实例绑定方法。

# classmethod还可以来预处理，生成初始化后的类
P = Pizza.compute_volume3(1, 2) 
```
