#!/bin/bash

#### 用法：在后台一直运行交付一个 7x24 的循环直播平台
#### nohup simulator >/dev/null 2>&1 &
#### jobs -l

count=1
while [ $count -lt 24000 ]
do
   echo "第 $count 次循环直播："


   echo "频道1：nginx module - hls"
   nohup ffmpeg -re -i videos/media4-1080p.mp4 -c copy -f flv rtmp://127.0.0.1:19359/hls/nginxmodule >nginxhls.log &
   process_id=$!

   wait $process_id
   status1=$?

   count=`expr $count + 1`
   if [ $status1 -ne 0 ]
   then
     echo "有错误发生，直播结束"
     exit 0
   fi
done
