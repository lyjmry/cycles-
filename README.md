# cycles-
通过shell实现cycles余额邮箱提醒
#!/bin/bash
# 获取系统名称
LINUX_OS=`cat /etc/issue | awk -F' ' '{print $1}'`

# 执行输出指令
input1(){
	echo "### 1.安装邮箱heirloom-mailx依赖  2.设置邮箱提醒  3.邮箱发送 4.其他退出 ###"
	read -p "Please choice：" flage
}

# 配置发送方邮箱
input2(){
	read -p "Please enter your email: " mail_name
	read -p "Please enter your email STMP service: " smtp
	read -p "Please enter your email authorization code: " auth_code 
}

# ubuntu安装依赖
install_ubuntu(){

	# 输出参数邮箱配置
	input2

	# 安装源
	`chmod 777 /etc/apt/sources.list`
	`"deb http://cz.archive.ubuntu.com/ubuntu xenial main universe" >> /etc/apt/sources.list`
	# 更新源
	`sudo apt-get update`
	# 安装邮箱功能
	`sudo apt-get install heirloom-mailx -y`
	# 配置邮箱服务
	# 1.邮箱名
	`"set from=$mail_name" >> /etc/s-nail.rc`
	# 2.邮箱服务smtp
	`"set smtp=$smtp" >> /etc/s-nail.rc`
	# 3.邮箱名
	`"set smtp-auth-user=$mail_name" >> /etc/s-nail.rc`
	# 4.授权码
	`"set smtp-auth-password=$auth_code" >> /etc/s-nail.rc`
	# 5.登录
	`"set smtp-auth=login" >> /etc/s-nail.rc`
}

# 邮箱发送余额提醒
email_send1(){
	input3
	getBanles
	time1=$(date "+%Y-%m-%d %H:%M:%S")
	time2=$(date --date='13 hour ago')
	utctime=$(date --date='8 hour ago')
	time3=$(date --date='1 hour')
	echo -e "当前余额：$banles, 北京时间：$time1 \n
	Current balance：$banles, New York Time：$time2 \n
	現在の残高：$banles, 東京時間：$time3 \n
	UTC: $utctime" | s-nail  -s "cycles小管家余额提醒" $mail
}

# 邮箱发送内容
email_send2(){
	input3
	time1=$(date "+%Y-%m-%d %H:%M:%S")
	time2=$(date --date='13 hour ago')	
	utctime=$(date --date='8 hour ago')		 
 	time3=$(date --date='1 hour')
	echo -e "余额提醒, 当前余额：$banles, 北京时间：$time1 \n
	Current balance：$banles, New York Time：$time2 \n
	現在の残高：$banles, 東京時間：$time3 \n
	UTC: $utctime" | s-nail  -s "cycles小管家余额提醒" $mail
}

email_send3(){
	time1=$(date "+%Y-%m-%d %H:%M:%S")
	time2=$(date --date='13 hour ago')	
	utctime=$(date --date='8 hour ago')		 
 	time3=$(date --date='1 hour')
	echo -e "余额提醒, 当前余额：$banles, 北京时间：$time1 \n
	Current balance：$banles, New York Time：$time2 \n
	現在の残高：$banles, 東京時間：$time3 \n
	UTC: $utctime" | s-nail  -s "cycles小管家余额提醒" $m
}

email_send4(){
	time1=$(date "+%Y-%m-%d %H:%M:%S")
	time2=$(date --date='13 hour ago')	
	utctime=$(date --date='8 hour ago')		 
 	time3=$(date --date='1 hour')
	echo -e "余额提醒, 当前余额：$banles, 北京时间：$time1 \n
	Current balance：$banles, New York Time：$time2 \n
	現在の残高：$banles, 東京時間：$time3 \n
	UTC: $utctime" | s-nail  -s "cycles小管家余额提醒" $1
}

# 输入需要发送的邮箱地址
input3(){
	read -p "Please enter your email: " mail
}

# 执行主方法
main(){

	while [ 1 ]
	do
		# 余额小于阈值1H发一次提醒， 大于24小时发一次
		input1
        	if [[ $flage == '1' ]];then
			install_ubuntu
		elif [[ $flage == '2' ]];then
			# 设置阈值
			read -p "Set balance threshold：" set_banles
			
			banles=`dfx wallet --network ic balance | awk -F' ' '{print $1}'`                                
			read -p "whether mass mailing -> (y/n): " fl
			if [[ $fl == "y" ]];then
				read -p "Please enter multiple mailboxes separated by spaces: " mails
				for m in $mails;do
					email_send3
				done
				#t='1h'
				t='10s'
			else
				if [[ "$banles" -lt "$set_banles" ]];then	
					email_send2						                                
					#t='1h'
					t='10s'
				else	
					email_send2     
					#t='24h'
					t='24s'
				fi												
			fi
			while [ i ]
			do
				echo "Please do not stop. You can use Ctrl + Z to execute in the background！"                                        
				sleep $t
				banles=`dfx wallet --network ic balance | awk -F' ' '{print $1}'`
				if [[ "$banles" -lt "$set_banles" ]];then                                        
					t='10s'
					#t='1h'
				else    
					#t='24h'				
					t='24s'				
				fi
				if [[ $fl == "y" ]];then
					for m in $mails;do					
						email_send4 $m
					done
				else
					email_send4 $mail
				fi
			done
		elif [[ $flage == '3' ]];then			   
   			email_send1

     		else			
			exit	
		fi
		
	done
}
# 执行
main























未来一个月可实现前端自定阈值 提醒时间和发送邮箱
