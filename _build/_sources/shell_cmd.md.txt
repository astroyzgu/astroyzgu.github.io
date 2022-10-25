# bash

### 用到的shell命令

``awk, cat, grep, sort`` 


``sort -nk 1 filename`` 参考：http://man.linuxde.net/sort

``sed -i '244d' filename  # Remove the first 244 lines (-i, Edit the file diectly)``

###### tail & head 
 
tail(head) - output the last(beginning) part of files

``tail -n  4 COSMOS.txt # print last 4 lines`` 

``tail -n +4 COSMOS.txt # output starting with the Kth to the end``



```
  paste -d -s file1 file2
  选项含义如下：
  -d 指定不同于空格或t a b键的域分隔符。例如用@分隔域，使用-d @。
  -s 将每个文件合并成行而不是按行粘贴。（行列转置会用到）
```
uniq
diff - http://www.lampweb.org/linux/3/17.html

tail -n +2 data.tbl | sort -nk 2  #从第二行开始，对第二列排序 
tail -n +2 data.tbl | sort -nk 2 | awk '{print $1}'  #从第二行开始，对第二列排序并只打印第一行

比较data.tbl 的满足条件的第一行和data2.tbl 中的第一的不同
tail -n +2 data.tbl | sort -nk 2 | awk '$2 > 0.75 {print $1}' > data1.tbl
tail -n +2 data2.tbl|awk '{print $1} ' > data3.tbl 
diff data1.tbl data2.tbl -y -W30 |awk '$1 != $2 '

### download/upload ######################################################### 
- 服务器上传或下载
  rsync --progress -avz  username@192.160.0.1:/data/reduction  .
- wget指定目录下所有文件
  wget -c -r -np -k -L -p -A '*.fits' http://data/location

### compresion/decompression ################################################
-  *.bz2                                                                      
   bzip2 -d *.tar.bz2
   tar -xf *.tar

### shell script ############################################################
# 字符串的赋值，替换和打印
sciname='../image/smacs0723-f356w_test_sci.fits'
whtname=${sciname/sci/wht}
echo 'sciname:  ' $sciname
echo 'whtname:  ' $whtname

# 判断字符串中是否包含某串字符
if echo $whtname | grep sci; then 
   echo 'contain sci'
else 
   echo 'not contain sci'
fi
