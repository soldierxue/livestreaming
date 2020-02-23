#!/bin/bash

### 启动 直播推流脚本
nohup 7x24dash.sh > dash-nohup.log &
nohup 7x24hls.sh > hls-nohup.log &
nohup 7x24srs.sh > srs-nohup.log &