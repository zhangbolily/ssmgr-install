#!/usr/bin/env bash
#
# Auto install shadowsocks-manager all necessary moudles
#
# System Required:  Debian8+, Ubuntu16+
#
# Copyright (C) 2017-2018 Ball Chang<zhangbolily@gmail.com>
#
# URL: https://ss.ballchang.men
#

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

[[ $EUID -ne 0 ]] && echo -e "${red}Error:${plain} This script must be run as root!" && exit 1

#---------Get the system type first-----------
#
#
#---------------------------------------------
if [ -f /etc/redhat-release ]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
fi

get_char() {
    SAVEDSTTY=`stty -g`
    stty -echo
    stty cbreak
    dd if=/dev/tty bs=1 count=1 2> /dev/null
    stty -raw
    stty echo
    stty $SAVEDSTTY
}
#---------Start the ssmgr all modules-----------
#
#
#---------------------------------------------

if commond -v screen > /dev/null; then
     continue
else echo -e "${red}Error: Commond screen doesn't exist.The script will terminate.${plain}"
     exit 1
fi

#---------ssmgr node-----------
read -p "Info: Do you want to start ssmgr node with configuration file /root/.ssmgr/ss.yml? [y/n]" is_start
if [[ ${is_start} == "y" || ${is_start} == "Y" ]]; then
    if screen -ls | grep -Eqi 'ssmgr';then
         echo -e "${green}---------- ssmgr ----------${plain}"
         echo "-----------------------------------------------------------------"
         echo " ssmgr is already running."
         echo
         echo "-----------------------------------------------------------------"
    else if screen -dmS ssmgr ssmgr -c /root/.ssmgr/ss.yml && screen -ls | grep -Eqi 'ssmgr'; then
              echo -e "${green}---------- ssmgr ----------${plain}"
              echo "-----------------------------------------------------------------"
              echo " ssmgr start successfuly with configuraion file /root/.ssmgr/ss.yml."
              echo
              echo "-----------------------------------------------------------------"
         else echo -e "${red}Error:${plain}---------- ssmgr start failed! ----------${plain}"
              echo
              echo -e "${red}Error:${plain}ssmgr start failed with configuration file /root/.ssmgr/ss.yml."
              echo -e "${red}Error:${plain}Please check if the file exists or configuration file is correct."
              echo
              echo "-----------------------------------------------------------------"
         fi
    fi
fi


#---------ssmgr webgui-----------
read -p "Info: Do you want to start ssmgr webgui with configuration file /root/.ssmgr/webgui.yml? [y/n]" is_start
if [[ ${is_start} == "y" || ${is_start} == "Y" ]]; then
    if screen -ls | grep -Eqi 'webgui';then
         echo -e "${green}---------- ssmgr ----------${plain}"
         echo "-----------------------------------------------------------------"
         echo " ssmgr's webgui is already running."
         echo
         echo "-----------------------------------------------------------------"
    else if screen -dmS webgui ssmgr -c /root/.ssmgr/webgui.yml && screen -ls | grep -Eqi 'webgui'; then
              echo -e "${green}---------- ssmgr ----------${plain}"
              echo "-----------------------------------------------------------------"
              echo " ssmgr start successfuly with configuraion file /root/.ssmgr/webgui.yml."
              echo
              echo "-----------------------------------------------------------------"
         else echo -e "${red}Error:${plain}---------- ssmgr start failed! ----------${plain}"
              echo
              echo -e "${red}Error:${plain}ssmgr start failed with configuration file /root/.ssmgr/webgui.yml."
              echo -e "${red}Error:${plain}Please check if the program exists or configuration file is correct."
              echo
              echo "-----------------------------------------------------------------"
         fi
    fi
fi

#---------shadowsocks manyuser-----------
read -p "Info: Do you want to start ss-manager? [y/n]" is_start
if [[ ${is_start} == "y" || ${is_start} == "Y" ]]; then
    if screen -ls | grep -Eqi 'ss-manager';then
         echo -e "${green}---------- ss-manager ----------${plain}"
         echo "-----------------------------------------------------------------"
         echo " ss-manager is already running."
         echo
         echo "-----------------------------------------------------------------"
    else if screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:4000 && screen -ls | grep -Eqi 'ss-manager'; then
              echo -e "${green}---------- ss-manager ----------${plain}"
              echo "-----------------------------------------------------------------"
              echo " ss-manager start successfuly!"
              echo
              echo "-----------------------------------------------------------------"
         else echo -e "${red}Error:${plain}---------- ss-manager start failed! ----------${plain}"
              echo
              echo -e "${red}Error:${plain}ss-manager start failed."
              echo -e "${red}Error:${plain}Please check if the program exists or configuration is correct."
              echo
              echo "-----------------------------------------------------------------"
         fi
    fi
fi

screen -ls

