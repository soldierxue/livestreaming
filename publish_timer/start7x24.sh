#!/bin/bash

# 启动 SRS 服务器

### 启动两个HA 的服务器

HostIP=`curl http://169.254.169.254/latest/meta-data/local-ipv4/`

docker run -d --rm -p 19350:19350 -p 9090:9090 --add-host=docker:${HostIP} \
    -v `pwd`/srs-docker/conf/origin.cluster.serverA.conf:/usr/local/srs/conf/srs.conf \
    ossrs/srs:3

docker run -d --rm -p 19351:19351 -p 9091:9091 --add-host=docker:${HostIP} \
    -v `pwd`/srs-docker/conf/origin.cluster.serverB.conf:/usr/local/srs/conf/srs.conf \
    ossrs/srs:3

docker run -d --rm -p 1935:1935 -p 1985:1985 -p 8080:8080 --add-host=docker:${HostIP} \
    -v `pwd`/srs-docker/conf/origin.cluster.edge.conf:/usr/local/srs/conf/srs.conf \
    ossrs/srs:3

### 启动 nginx + rtmp 模块
sudo systemctl restart nginx

### 启动 直播推流脚本
nohup 7x24dash.sh > dash-nohup.log &
nohup 7x24hls.sh > hls-nohup.log &
nohup 7x24srs.sh > srs-nohup.log &