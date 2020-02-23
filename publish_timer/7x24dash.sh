#!/bin/bash

#### 用法：在后台一直运行交付一个 7x24 的循环直播平台
#### nohup 7x24dash.sh >/dev/null 2>&1 &
#### jobs -l

count=1
while [ $count -lt 24000 ]
do
   echo "第 $count 次循环直播："

   echo "频道2：nginx module - dash"
   nohup ffmpeg -re -i videos/media3-1080p.mp4 -c copy -f flv rtmp://127.0.0.1:19359/dash/nginxmodule >nginxdash.log &
   process_id2=$!

   wait $process_id2
   status2=$?

   count=`expr $count + 1`
   if [ $status2 -ne 0 ]
   then
     echo "有错误发生，直播结束"
     exit 0
   fi
done
