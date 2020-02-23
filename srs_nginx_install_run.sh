#!/bin/bash

# 在 Ubuntu 上安装 Nginx 和 RTMP 模块
sudo apt update
sudo apt upgrade
sudo apt install nginx
sudo apt install libnginx-mod-rtmp

# 更新 nginx 配置
## 参考：./nginx_conf/nginx.conf
sudo vi /etc/nginx/nginx.conf

# 启动 nginx + rtmp 模块
sudo systemctl restart nginx

#######################

# 安装 docker 以及 下载 srs-docker 相关配置

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
apt-cache policy docker-ce
sudo apt-get install -y docker-ce
sudo systemctl status docker

# 将 普通用户 ubuntu 加入到 docker group
sudo usermod -aG docker ubuntu

# Logout & Login agagin to eanble ubuntu the access directly the docker commend
# check docker status
docker info

# download the demo files and configurations
git clone https://github.com/ossrs/srs-docker.git

# 获得 EC2 的 IPv4 的本地地址
HostIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4/`

### 启动两个 HA 的服务器以及 Edge 服务器

docker run -d --rm -p 19350:19350 -p 9090:9090 --add-host=docker:${HostIP} \
    -v `pwd`/srs-docker/conf/origin.cluster.serverA.conf:/usr/local/srs/conf/srs.conf \
    ossrs/srs:3

docker run -d --rm -p 19351:19351 -p 9091:9091 --add-host=docker:${HostIP} \
    -v `pwd`/srs-docker/conf/origin.cluster.serverB.conf:/usr/local/srs/conf/srs.conf \
    ossrs/srs:3

docker run -d --rm -p 1935:1935 -p 1985:1985 -p 8080:8080 --add-host=docker:${HostIP} \
    -v `pwd`/srs-docker/conf/origin.cluster.edge.conf:/usr/local/srs/conf/srs.conf \
    ossrs/srs:3

