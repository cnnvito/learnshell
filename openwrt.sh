#/bin/bash

#检测是否输入正确的线程数，最高支持8线程编译
if [ -z "$1" ]; then
	xc=1
else 
	case $1 in
		[1-9]) xc=$1
		;;
		*)	
			echo
			echo
			echo
			echo "你在脚本后面输入了奇怪的参数，脚本后面只允许填1-9的线程数~~~"
			echo
			echo
			echo
			exit 0
		;;
	esac
fi

clear

echo "

这个脚本编译的固件是x86_64专用哦！！傻瓜式编译脚本。。

要是脚本执行不成功，可以在脚本发布页面下方评论。

贴上你失败时输出的命令，博主看到的话会尽力帮忙解决哦。

此脚本发布于 愉悦人生 https://www.cnvito.top
"

while :;do
read -p "你确定要运行这个脚本? [y/n]: " YN
case $YN in 
	[Yy])
		echo "好的，马上运行"
		break
	;;
	[Nn]) 
		echo
		echo "退出脚本"
		exit 0
	;;
	*)
		echo "你输入的啥玩意儿~~"
	;;
esac
done

if [ "$USER" = "root" -o "$USER" = "git" ]; then
	echo
	echo
	echo "想运行也不可以，因为你用的是$USER用户，不可以用root或者git用户编译哦，换一个普通用户吧~~"
	sleep 3s
	exit 0
fi

clear

echo "

1.我想要和Lean大一样的默认配置就行了

2.我想要和博主一样的配置

3.我想要自定义配置

4.我想要退出这个辣鸡脚本

"
echo
echo
echo

while :; do

read -p "你想要哪个配置？ " CHOOSE

case $CHOOSE in
	1)
		echo
		echo
		echo
		echo "正在下载Lean大的默认配置文件......"
		curl -O http://download.cnvito.top/.config-lean
	break
	;;
	2)
		echo
		echo
		echo
		echo "正在下载博主的配置文件......"
		curl -O http://download.cnvito.top/.config-bozhu
	break
	;;
	3)
		echo
		echo
		echo "对不起，自定义选择的配置文件太多，太复杂了，不准备搞自定义了。"
		echo "但是你可以看看博主的这篇文章 https://www.cnvito.top/37.html"
		exit 0
	;;
	4)	exit 0
	;;
	*) 
		echo
		echo
		echo
		echo "大哥，你输这玩意儿,我不知道你想干嘛呀。。。"
	;;
esac
done
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
echo
"
1.你可以随时按Ctrl+C停止编译

2.第一次编译的速度很慢，为了求稳，这个脚本默认是用单线程编译的

3.建议你学会给这台编译机全局翻墙，不然很大几率会编译失败，肉身在外当我没说~

4.你选择了$xc线程编译哦，第一次编译建议使用1，即单线程编译

"

for ((i=10;i>=1;i--)); do
echo -ne "等待$i秒后继续运行\r"
sleep 1s
done

clear

if [ ! -d "~/lede" ]; then
	cd ~ && git clone https://github.com/coolsnowwolf/lede.git
fi

cd ~/lede/ && git pull

~/lede/scripts/feeds update -a && ~/lede/scripts/feeds install -a

cat ~/.config-* > ~/lede/.config && rm -f ~/.config-*

make -j$xc V=s

clear

echo "

编译完成，本次编译的固件存放在/home/$USER/lede/targets/x86/64下

固件后台登陆默认用户名密码  root password

脚本发布于愉悦人生https://www.cnvito.top/143.html

永远相信美好的事情即将发生！

"
#我的中二病都要犯了，我滴妈呀。。。
#迟点写一个全局翻墙的脚本，算是半智能化把。
