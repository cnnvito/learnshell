#/bin/bash

config_daili() {
#ssr配置文件
	cat > /etc/shadowsocksr/config.json <<-EOF
	{
		"server": "0.0.0.0",
		"server_ipv6": "::",
		"server_port": 8388,
		"local_address": "127.0.0.1",
		"local_port": 1080,

		"password": "m",
		"method": "aes-128-ctr",
		"protocol": "auth_aes128_md5",
		"protocol_param": "",
		"obfs": "tls1.2_ticket_auth_compatible",
		"obfs_param": "",
		"speed_limit_per_con": 0,
		"speed_limit_per_user": 0,

		"additional_ports" : {},
		"additional_ports_only" : false,
		"timeout": 120,
		"udp_timeout": 60,
		"dns_ipv6": false,
		"connect_verbose_info": 0,
		"redirect": "",
		"fast_open": false
	}
	EOF
}
<<'COMMENT'
start_daili() {
#开启代理
	if [ ! -e "/etc/shadowsocksr/config.json" ]; then
		clear
		echo
		echo
		echo "你好像没有完整的执行过此脚本，请不要加start参数运行一遍脚本。"
		exit 0
	fi
	service privoxy restart
	python /usr/local/shadowsocksr/shadowsocks/local.py -c /etc/shadowsocksr/config.json -d start
	cp -af /etc/environment.start /etc/environment
	source /etc/environment
}

stop_daili() {
#停止代理
	if [ ! -e "/etc/shadowsocksr/config.json" ]; then
		clear
		echo
		echo
		echo "你好像没有完整的执行过此脚本，请不要加stop参数运行一遍脚本。"
		exit 0
	fi
	service privoxy stop
	python /usr/local/shadowsocksr/shadowsocks/local.py  -c /etc/shadowsocksr/config.json -d stop
	cp -af /etc/environment.stop /etc/environment
	source /etc/environment
}
COMMENT
del_daili() {
#删除脚本配置
	service privoxy stop
	apt-get -y remove privoxy
	python /usr/local/shadowsocksr/shadowsocks/local.py -c /etc/shadowsocksr/config.json -d stop
	rm -rf /etc/shadowsocksr && rm -rf /usr/local/shadowsocksr
	mv /etc/environment.bak /etc/environment && rm -f /etc/environment.stop /etc/environment.start
	source /etc/environment
	cd /etc/init.d && update-rc.d -f privoxy.sh remove && rm -f /etc/init.d/privoxy.sh
}

#-------------------------------------------------#

#判断是否存在config.json配置文件
if [ ! -d "/etc/shadowsocksr" ]; then
	mkdir /etc/shadowsocksr
	config_daili
elif [ -d "/etc/shadowsocksr" ]; then
	:
elif [ ! -e "/etc/shadowsocksr/config.json" ]; then 
	config_daili
	else echo "已存在配置文件"
fi

clear

#start or stop 
<<'COMMENT'
case $1 in
	start)
		start_daili
		exit 0
	;;
	stop)
		stop_daili
		exit 0
	;;
	*)
		echo "仅支持start和stop两个参数"
	;;
esac
clear
COMMENT
echo
echo
echo 
"
***开启代理前，请在/etc/shadowsocksr/config.json填好你的\$\$节点信息。

1.我现在填写节点信息。

2.我已经填好我的节点信息。

3.删除代理配置
"
echo
while true; do
	read -p "填好了节点信息？还是删除代理配置？输入前方数字作出你的选择: " XX
	case $XX in
	2)
		break
	;;
	3)
		del_daili
		exit 0
	;;
	*)
		exit 0
	;;
	esac
done

echo
echo
echo
for ((i=5;i>=1;i--)); do 
	echo -ne "脚本即将运行，若填写的节点信息不正确，开启代理后将不能正常联网。$i s\r"
	sleep 1s
done
clear

apt-get -y update && apt-get -y install git wget curl privoxy

if [ ! -d "/usr/local/shadowsocksr" ]; then
	cd /usr/local && git clone https://github.com/ssrbackup/shadowsocksr 
fi

#配置privoxy
sed -i "s/listen-address  localhost:8118/#listen-address  localhost:8118/g" /etc/privoxy/config
cat >> /etc/privoxy/config <<-EOF
forward-socks5t / 127.0.0.1:1080 .
listen-address 127.0.0.1:8118
EOF
service privoxy restart
#开启shadowsocksr
python /usr/local/shadowsocksr/shadowsocks/local.py -c /etc/shadowsocksr/config.json -d start
#全局代理写入环境变量
cp -a /etc/environment /etc/environment.bak && cp -a /etc/environment /etc/environment.stop
cat >> /etc/environment <<-EOF
export http_proxy=http://127.0.0.1:8118
export https_proxy=http://127.0.0.1:8118
EOF
source /etc/environment
cp -a /etc/environment /etc/environment.start
#开机自启脚本，开机直接连上代理
cat > /etc/init.d/privoxy.sh <<-EOF
#/bin/bash 
python /usr/local/shadowsocksr/shadowsocks/local.py -c /etc/shadowsocksr/config.json -d start
EOF
chmod 755 /etc/init.d/privoxy.sh
cd /etc/init.d && update-rc.d privoxy.sh defaults 90
clear

echo
"
全局代理配置完成。

已配置开机自动代理。

若无法联网，请检查你的节点信息是否正确。
"
