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

build_shadowsocks_libev_dev() {
    cd ~
    git clone https://github.com/shadowsocks/shadowsocks-libev.git
    cd ./shadowsocks-libev
    mkdir -p ~/build-area/
    cp ./scripts/build_deb.sh ~/build-area/
    cd ~/build-area
    ./build_deb.sh
}

#---------Install necessary modules-----------
#
#
#---------------------------------------------
if [ "${release}" == "ubuntu" ] || [ "${release}" == "debian" ]; then
	 #System update
	 apt-get update
	 #Install necessary moudles
	 apt-get install -y build-essential wget curl tar unzip gettext build-essential screen autoconf automake libtool openssl libssl-dev zlib1g-dev xmlto asciidoc libpcre3-dev libudns-dev libev-dev nano software-properties-common git
else echo -e "${red}Error:${plain}---------- System Error! ----------${plain}"
     echo
     echo -e "${red}Error:${plain}Your Linux distribution is not supported by this script."
     echo -e "${red}Error:${plain}This script will be terminated."
     echo "-----------------------------------------------------------------"
     exit 1
fi

#-----------Install nodejs v6-----------------
#
#
#---------------------------------------------
cd ~
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
apt-get install -y nodejs
if node -v | grep -Eqi "v6"; then
          echo -e "${green}---------- Nodejs Information ----------${plain}"
          echo "-----------------------------------------------------------------"
          echo " Nodejs v6 installed successfully!"
          echo " Press any key to continue...or Press Ctrl+C to cancel"
          echo "-----------------------------------------------------------------"
          char=`get_char`
else echo -e "${red}Error:---------- Nodejs Installation Error! ----------${plain}"
     echo "-----------------------------------------------------------------"
     echo -e "${red}Error:${plain}There are some problem occured in the installation of Nodejs."
     echo -e "${red}Error:${plain}Please notify the output of terminal to determin how to solve this problem."
     echo -e "${red}Error:${plain}We strongly recommend you to use commond "nodejs -v" to check again."
     echo -e "${red}Error:${plain}This script will be terminated."
     echo "-----------------------------------------------------------------"
     exit 1
fi

#---------Install shadowsocks-libev-----------
#
#
#---------------------------------------------
if [ "${release}" == "ubuntu" ]; then
     add-apt-repository ppa:max-c-lv/shadowsocks-libev
     apt-get update
     apt install shadowsocks-libev
     if dpkg -l | grep -Eqi "shadowsocks-libev"; then
          echo -e "${green}---------- shadowsocks-libev Information ----------${plain}"
          echo "-----------------------------------------------------------------"
          echo " shadowsocks-libev installed successfully!"
          echo " Press any key to continue...or Press Ctrl+C to cancel"
          echo "-----------------------------------------------------------------"
          char=`get_char`
     else echo -e "${red}Error:---------- shadowsocks-libev Installation Error! ----------${plain}"
          echo "-----------------------------------------------------------------"
          echo -e "${red}Error:${plain}There are some problem occured in the installation of shadowsocks-libev."
          echo -e "${red}Error:${plain}Please notify the output of terminal to determin how to solve this problem."
          echo -e "${red}Error:${plain}We strongly recommend you to use commond \"dpkg -l | grep -i \"shadowsocks-libev\"\" to check again."
          echo -e "${green}Notice:Do you want to build the shadowsocks-libev package now?${plain}"
          echo -e "${green}Notice:This may take a long time.${plain}"
          echo " Press any key to continue...or Press Ctrl+C to cancel"
          echo "-----------------------------------------------------------------"
          char=`get_char`

          build_shadowsocks_libev_dev

          if dpkg -l | grep -Eqi "shadowsocks-libev"; then
               echo -e "${green}---------- shadowsocks-libev Information ----------${plain}"
               echo "-----------------------------------------------------------------"
               echo " shadowsocks-libev installed successfully!"
               echo " Press any key to continue...or Press Ctrl+C to cancel"
               echo "-----------------------------------------------------------------"
               char=`get_char`
          else echo -e "${red}Error:---------- shadowsocks-libev Installation Error! ----------${plain}"
               echo "-----------------------------------------------------------------"
               echo -e "${red}Error:${plain}There are some problem occured in the installation of shadowsocks-libev."
               echo -e "${red}Error:${plain}Please notify the output of terminal to determin how to solve this problem."
               echo -e "${red}Error:${plain}We strongly recommend you to use commond \"dpkg -l | grep -i \"shadowsocks-libev\"\" to check again."
               echo -e "${red}Error:${plain}This script will be terminated."
               echo "-----------------------------------------------------------------"
               exit 1
          fi
      fi

elif [ "${release}" == "debian" ]; then
     sh -c 'printf "deb http://deb.debian.org/debian jessie-backports-sloppy main" > /etc/apt/sources.list.d/jessie-backports.list'
     apt update
     apt -t jessie-backports-sloppy install shadowsocks-libev

     if dpkg -l | grep -Eqi "shadowsocks-libev"; then
          echo -e "${green}---------- shadowsocks-libev Information ----------${plain}"
          echo "-----------------------------------------------------------------"
          echo " shadowsocks-libev installed successfully!"
          echo " Press any key to continue...or Press Ctrl+C to cancel"
          echo "-----------------------------------------------------------------"
          char=`get_char`
     else echo -e "${red}Error:---------- shadowsocks-libev Installation Error! ----------${plain}"
          echo "-----------------------------------------------------------------"
          echo -e "${red}Error:${plain}There are some problem occured in the installation of shadowsocks-libev."
          echo -e "${red}Error:${plain}Please notify the output of terminal to determin how to solve this problem."
          echo -e "${red}Error:${plain}We strongly recommend you to use commond \"dpkg -l | grep -i \"shadowsocks-libev\"\" to check again."
          echo -e "${green}Notice:Do you want to build the shadowsocks-libev package now?${plain}"
          echo -e "${green}Notice:This may take a long time.${plain}"
          echo " Press any key to continue...or Press Ctrl+C to cancel"
          echo "-----------------------------------------------------------------"
          char=`get_char`

          build_shadowsocks_libev_dev

          if dpkg -l | grep -Eqi "shadowsocks-libev"; then
               echo -e "${green}---------- shadowsocks-libev Information ----------${plain}"
               echo "-----------------------------------------------------------------"
               echo " shadowsocks-libev installed successfully!"
               echo " Press any key to continue...or Press Ctrl+C to cancel"
               echo "-----------------------------------------------------------------"
               char=`get_char`
          else echo -e "${red}Error:---------- shadowsocks-libev Installation Error! ----------${plain}"
               echo "-----------------------------------------------------------------"
               echo -e "${red}Error:${plain}There are some problem occured in the installation of shadowsocks-libev."
               echo -e "${red}Error:${plain}Please notify the output of terminal to determin how to solve this problem."
               echo -e "${red}Error:${plain}We strongly recommend you to use commond \"dpkg -l | grep -i \"shadowsocks-libev\"\" to check again."
               echo -e "${red}Error:${plain}This script will be terminated."
               echo "-----------------------------------------------------------------"
               exit 1
          fi
     fi
fi

#--------Install shadowsocks-manager---------
#
#
#---------------------------------------------
npm i -g shadowsocks-manager

if ssmgr --version | grep -Eqi "shadowsocks-manager"; then
     echo -e "${green}---------- shadowsocks-manager Information ----------${plain}"
     echo "-----------------------------------------------------------------"
     echo " shadowsocks-manager installed successfully!"
     echo " Press any key to continue...or Press Ctrl+C to cancel"
     echo "-----------------------------------------------------------------"
     char=`get_char`
else echo -e "${red}Error:---------- shadowsocks-manager Installation Error! ----------${plain}"
     echo "-----------------------------------------------------------------"
     echo -e "${red}Error:${plain}There are some problem occured in the installation of shadowsocks-manager."
     echo -e "${red}Error:${plain}Please notify the output of terminal to determin how to solve this problem."
     echo -e "${red}Error:${plain}We strongly recommend you to use commond \"ssmgr --version\" to check again."
     echo -e "${red}Error:${plain}This script will be terminated."
     echo "-----------------------------------------------------------------"
     exit 1
fi

#--------Create Configuration File-----------
#
#
#---------------------------------------------

cd ~
mkdir -p ~/.ssmgr/
echo "type: s
empty: false
shadowsocks:
  address: 127.0.0.1:4000
manager:
  address: 0.0.0.0:4001
  password: xxxxxx
db: 'ss.sqlite'" > ./.ssmgr/ss.yml

if [ -f ~/.ssmgr/ss.yml ]; then
     echo -e "${green}---------- File Created ----------${plain}"
     echo "-----------------------------------------------------------------"
     echo " The file ss.yml has been created in folder ~/.ssmgr."
     echo " Please check the file after installation."
     echo " Here is the content of the file:"
     echo "type: s"
     echo "empty: false"
     echo "shadowsocks:"
     echo "  address: 127.0.0.1:4000"
     echo "manager:"
     echo "  address: 0.0.0.0:4001"
     echo "  password: xxxxxx"
     echo "db: 'ss.sqlite'"
     echo "-----------------------------------------------------------------"
else
     echo -e "${red}Error:---------- File Created Failed ----------${plain}"
     echo -e "${red}Error:${plain}The file ss.yml has been created in folder ~/.ssmgr failed."
     echo -e "${red}Error:${plain}Please notify this message and fix it manually."
     echo "-----------------------------------------------------------------"
fi

#---------------Start the ssmgr---------------
#
#
#---------------------------------------------
screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:4000
screen -dmS ssmgr ssmgr -c /root/.ssmgr/ss.yml

if screen -ls | grep -Eqi "ssmgr|ss-manager"; then
     echo -e "${green}---------- Shadowsocks-manager works! ----------${plain}"
     echo "-----------------------------------------------------------------"
     echo " Shadowsocks-manager is working."
     echo " Use commond [ screen -ls ] to check it."
     screen -ls
     echo " Press any key to continue...or Press Ctrl+C to cancel"
     echo "-----------------------------------------------------------------"
     char=`get_char`
else echo -e "${red}Error:---------- Start Shadowsocks-manager Failed! ----------${plain}"
     echo "-----------------------------------------------------------------"
     echo -e "${red}Error:${plain}There are some problem occured with shadowsocks-manager."
     echo -e "${red}Error:${plain}Please notify the output of terminal to determin how to solve this problem."
     echo -e "${red}Error:${plain}We strongly recommend you to use commond \"screen -ls\" to check again."
     echo -e "${red}Error:${plain}This script won't be terminated.However, you have to notice this error."
     echo -e "${red}Error:${plain}Because shadowsocks-manager won't work well in the future as well."
     echo " Press any key to continue...or Press Ctrl+C to cancel"
     echo "-----------------------------------------------------------------"
     char=`get_char`
fi

#---------------Install BBR------------------
#
#
#---------------------------------------------
read -p "Info: Do you want to install BBR for your system? [y/n]" is_install
if [[ ${is_install} == "y" || ${is_install} == "Y" ]]; then
    wget --no-check-certificate https://github.com/teddysun/across/raw/master/bbr.sh
    chmod +x bbr.sh
    ./bbr.sh
fi

#-----------Create startup script-------------
#
#
#---------------------------------------------
echo "screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:4000
screen -dmS ssmgr ssmgr -c /root/.ssmgr/ss.yml" > ~/.ssmgr/run_ssmgr.sh
chmod 755 ~/.ssmgr/run_ssmgr.sh

if [ -f ~/.ssmgr/run_ssmgr.sh ]; then
     echo -e "${green}---------- File Created ----------${plain}"
     echo "-----------------------------------------------------------------"
     echo " The file run_ssmgr.sh has been created in folder ~/.ssmgr."
     echo " Please check the file after installation."
     echo " Here is the content of the file:"
     echo " screen -dmS ss-manager ss-manager -m aes-256-cfb -u --manager-address 127.0.0.1:4000"
     echo " screen -dmS ssmgr ssmgr -c /root/.ssmgr/ss.yml"
     echo "-----------------------------------------------------------------"
else echo -e "${red}Error:---------- File Created Failed ----------${plain}"
     echo -e "${red}Error:${plain}The file run_ssmgr.sh has been created in folder ~/.ssmgr failed."
     echo -e "${red}Error:${plain}Please notify this message and fix it manually."
     echo "-----------------------------------------------------------------"
fi

echo "---------- Installation Finished ----------"
echo "All of the installation work has been done."
echo -e "${red}You need to check all of the parts if work well.${plain}"
echo
echo "----------------------------------------"
