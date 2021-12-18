#!/bin/bash
# 邮箱发送
onlySendMail(){
	        time1=$(date "+%Y-%m-%d %H:%M:%S")	
		time2=$(date --date='13 hour ago')	        
		utctime=$(date --date='8 hour ago')		        
		time3=$(date --date='1 hour')			        
		echo -e "余额提醒, 当前余额：$1, 北京时间：$time1 \n					
		Current balance：$1, New York Time：$time2 \n						     
	     	現在の残高：$1, 東京時間：$time3 \n     							
		UTC: $utctime" | s-nail  -s "cycles小管家余额提醒" $2
							
}

onlySendMail $1 $2
