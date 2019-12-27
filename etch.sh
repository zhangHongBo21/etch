#!/bin/sh
echo "******************以太坊节点服务器开始搭建*****************"
read -p "是否开始搭建以太坊节点服务器，以及确保根目录下不存在parity文件夹?[y/n]" input
if [ $input = "y" ];then
    echo "******************开始构建节点*****************"
else
  echo "******************退出节点构建*****************"
  exit 0
fi
cd /
if [ ! -d "/parity" ]; then
  mkdir "parity"
else
  echo "******************parity目录已存在，请更改路径*****************"
  exit 0
fi

echo "******************创建parity目录成功*****************"
cd /parity
wget https://releases.parity.io/ethereum/v2.6.7/x86_64-unknown-linux-gnu/parity
echo "******************parity下载成功*****************"
chmod -R 777 /parity
wget http://ftp.gnu.org/gnu/gcc/gcc-7.3.0/gcc-7.3.0.tar.gz
echo "******************gcc下载成功*****************"
tar -xvf gcc-7.3.0.tar.gz
cd gcc-7.3.0
yum  install -y bzip2
echo "******************bzip2下载成功*****************"
./contrib/download_prerequisites
cd ../
mkdir gcc-build-7.3.0
echo "******************编译目录创建成功*****************"
cd gcc-build-7.3.0
yum install -y gcc-c++
if [ $? -ne 0 ]; then
    echo "------------------------gcc-c++下载失败---------------------"
    exit 0
fi
../gcc-7.3.0/configure --enable-checking=release --enable-languages=c,c++ --disable-multilib
if [ $? -ne 0 ]; then
    echo "--------------------gcc-configure命令失败------------------"
    exit 0
fi
echo "******************gcc-c++下载成功*****************"
make -j4
make install
if [ $? -ne 0 ]; then
    echo "GCC编译失败"
    exit 0
fi
echo "******************gcc编译成功*****************"
cp /parity/gcc-build-7.3.0/stage1-x86_64-pc-linux-gnu/libstdc++-v3/src/.libs/libstdc++.so.6.0.24 /usr/lib64
cd /usr/lib64
rm -rf libstdc++.so.6
ln -s libstdc++.so.6.0.24 libstdc++.so.6
if [ $? -ne 0 ]; then
    echo "GCC软连接更新失败"
    exit 0
fi
echo "******************软连接成功更新*****************"
cd /parity
wget http://ftp.gnu.org/gnu/glibc/glibc-2.18.tar.gz
tar zxf glibc-2.18.tar.gz
cd glibc-2.18/
mkdir build
cd build/
../configure --prefix=/usr
if [ $? -ne 0 ]; then
    echo "-----------------glibcc-configure命令失败--------------------"
    exit 0
fi
make -j2
make install
if [ $? -ne 0 ]; then
    echo "-----------------glibcc-编译失败------------------------"
    exit 0
fi
echo "******************安装成功*****************"
cd /parity
./parity
