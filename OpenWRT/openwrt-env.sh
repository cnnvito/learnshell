#/bin/bash
echo
echo
echo "这个脚本仅合适Ubuntu14 x64下部署基本环境
本脚本发布于 愉悦人生 https://www.cnvito.top"
echo
echo

while true; do
read -p "你确定要运行这个小白脚本吗？ [y/n] " YN
case $YN in 
	[Yy])
		echo "好的，正在运行......"
		break
	;;
	[Nn])
		echo "退出脚本......"
		exit 0
	;;
	*)	echo "我不懂你输入的是什么意思......"
	;;
esac
done

mv /etc/apt/sources.list /etc/apt/sources.list.bak && touch /etc/apt/sources.list

echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-updates main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-backports main restricted universe multiverse
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main restricted universe multiverse
# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ trusty-security main restricted universe multiverse" > /etc/apt/sources.list

apt-get update

apt-get -y install wget build-essential git asciidoc binutils bzip2 gawk gettext git libncurses5-dev libz-dev patch unzip zlib1g-dev lib32gcc1 libc6-dev-i386 subversion flex uglifyjs git-core gcc-multilib p7zip p7zip-full msmtp libssl-dev texinfo libglib2.0-dev upx autoconf automake libtool autopoint

clear 
echo
echo 
echo 
echo "|*******************************************|"
echo "|                                           |"
echo "|                                           |"
echo "|           基本环境部署完成......          |"
echo "|                                           |"
echo "|                                           |"
echo "|*******************************************|"
echo
