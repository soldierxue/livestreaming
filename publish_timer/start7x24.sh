#!/bin/bash

nohup 7x24dash.sh > dash-nohup.log &
nohup 7x24hls.sh > hls-nohup.log &
nohup 7x24srs.sh > srs-nohup.log &