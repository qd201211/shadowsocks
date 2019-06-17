#!/bin/bash
shellname=kcpshell.sh
yh='"'
	apt update&&apt install curl screen sysv-rc-conf -y
	cp /usr/sbin/sysv-rc-conf /usr/sbin/chkconfig

chmod +x server_linux_amd64
	ip=$(wget -qO- -t1 -T2 ipinfo.io/ip)
	if [[ -z "${ip}" ]]; then
		ip=$(wget -qO- -t1 -T2 api.ip.sb/ip)
		if [[ -z "${ip}" ]]; then
			ip=$(wget -qO- -t1 -T2 members.3322.org/dyndns/getip)
			if [[ -z "${ip}" ]]; then
				ip="VPS_IP"
			fi
		fi
	fi
	
clear
echo 开始生成配置
stty erase '^H' && read -p "(加速端口 默认: 7777):" speedprot
	[[ -z "${speedprot}" ]] && speedprot="7777"
stty erase '^H' && read -p "(服务器监听端口 默认: 29900):" localprot
	[[ -z "${localprot}" ]] && localprot="29900"
stty erase '^H' && read -p "(远程服务器地址 默认: 自动获取):" remoteip
	[[ -z "${remoteip}" ]] && remoteip=${ip}
stty erase '^H' && read -p "(密码 默认: myktw777):" key
	[[ -z "${key}" ]] && key=myktw777
stty erase '^H' && read -p "(加密方式 默认: none):" crypt
	[[ -z "${crypt}" ]] && crypt=none
stty erase '^H' && read -p "(加速模式 默认: fast):" speedmodel
	[[ -z "${speedmodel}" ]] && speedmodel=fast
stty erase '^H' && read -p "(服务器使用核心数量 默认: 2):" score
	[[ -z "${score}" ]] && score=2
stty erase '^H' && read -p "(客户端使用核心数量 默认: 2):" ccore
	[[ -z "${ccore}" ]] && ccore=2
	
	cat > server.kcptun.json <<-EOF
{
	"target": "127.0.0.1:$speedprot",
	"listen": ":$localprot",
	"key": "$key",
	"crypt": "$crypt",
	"mode": "$speedmodel",
	"mtu": 1350,
	"sndwnd": 512,
	"rcvwnd": 512,
	"datashard": 10,
	"parityshard": 3,
	"dscp": 46,
	"nocomp": true,
	"quiet": false,
	"sockbuf": 16777217,
	"scavengettl": -1,
	"dscp": 46,
	"conn": $score
}
EOF
echo -e "客户端配置开始-->
{
	"$yh"localaddr"$yh": "$yh":$speedprot"$yh",
	"$yh"remoteaddr"$yh": "$yh"$remoteip:$localprot"$yh",
	"$yh"key"$yh": "$yh"$key"$yh",
	"$yh"crypt"$yh": "$yh"$crypt"$yh",
	"$yh"mode"$yh": "$yh"$speedmodel"$yh",
	"$yh"mtu"$yh": 1350,
	"$yh"sndwnd"$yh": 512,
	"$yh"rcvwnd"$yh": 512,
	"$yh"datashard"$yh": 10,
	"$yh"parityshard"$yh": 3,
	"$yh"dscp"$yh": 46,
	"$yh"nocomp"$yh": true,
	"$yh"quiet"$yh": false,
	"$yh"sockbuf"$yh": 16777217,
	"$yh"scavengettl"$yh": -1,
	"$yh"dscp"$yh": 46,
	"$yh"conn"$yh": $ccore
}
<--客户端配置结束"

screen_name=$"kcp"
cmd=$"cd $(pwd)&&./server_linux_amd64 -c server.kcptun.json"
cat > ${shellname} <<-EOF
#!/bin/bash
screen -dmS "$screen_name"
screen -x -S "$screen_name" -p 0 -X stuff "$cmd"
screen -x -S "$screen_name" -p 0 -X stuff $'\n'
EOF
#echo -e 服务器启动脚本路径$(pwd)/$shellname
echo -e 自动启动中
chmod +x $shellname
chkconfig --add $shellname
chkconfig $shellname on
bash $shellname
echo -e 启动完成