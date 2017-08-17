ssmgr-install
=============

ssmgr的辅助脚本，包含了这两个脚本：
- ssmgr-install.sh：安装ssmgr所需的环境和主程序
- ssmgr-start.sh：启动ssmgr

目前支持的系统：
- Debian 8+
- Ubuntu 14.04+

ssmgr-install
------
安装过程中需要多次确认，请不要离开您的终端。

Debian / Ubuntu:

    cd ~
    git clone https://github.com/zhangbolily/ssmgr-install.git
    cd ssmgr-install
    bash ./ssmgr-install.sh

ssmgr-start
------

Debian / Ubuntu:

    cd ~
    git clone https://github.com/zhangbolily/ssmgr-install.git
    cd ssmgr-install
    bash ./ssmgr-start.sh

常见问题
------
#### 1、ssmgr 无法启动

ssmgr无法成功启动的原因很多，使用基本安装不能够确保ssmgr一定可以正常工作。需要解决这一问题请留意脚本安装时的输出，以及ssmgr运行时的输出。

已知错误：
- a: "have no access"这一类问题，指的是shadowsocks-manager 根目录下node_moudules/sqlite3这个文件夹权限有问题。

- 一般解决办法：
      chmod -R 755 shadowsocks-manager根目录/node_moudules/sqlite3
      chown -R root shadowsocks-manager根目录/node_moudules/sqlite3
- b: 提示sqlite3找不到模块之类的错误，根据红色信息的提示安装好sqlite3即可。
- 一般解决办法：
      cd shadowsocks-manager根目录
      npm install sqlite3 --save

### 2、添加服务器失败
两种原因可能性比较大：

- 1、密码不正确

- 请立刻检查您的ssmgr节点端配置文件，使用脚本安装的默认密码是无效的，您必须手动修改才可以保证安全。

- 2、服务器端口未开放

- 请检查您的服务器安全组或防火墙规则确定开放了4001端口的TCP协议。

### 3、如何赞助？
扫描下方二维码即可赞助

![Alipay QRCode]

[Alipay QRCode]:https://ss.ballchang.men/ss_resource/image/alipay_500px.png
