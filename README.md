#!/bin/bash

# 功能选择
format_check(){
	echo -e "\033[34m  中文：{ 0.配置发送邮箱 1.单发邮箱测试 2.单发送邮箱提醒设置 3.群发邮箱测试 4.群发邮箱提醒设置 5或其他：退出 }  English：{0.Configure sending mailbox 1.Single email test 2.Single send mailbox reminder settings 3.group email test 4.group email reminder settings  5 or ohter: exit }  \033[0m"
	read -p "Please select the number：" oper1
}

# Ubuntu依赖安装
installMailboxDependenciesUbuntu(){
	`chmod 777 /etc/apt/sources.list`
	isConf=`cat /etc/apt/sources.list | grep "xenial main universe"`
	if [[ ! -n "$isConf" ]];then
		
		`"deb http://cz.archive.ubuntu.com/ubuntu xenial main universe" >> /etc/apt/sources.list`
	fi
	`sudo apt-get update`
	`sudo apt-get install heirloom-mailx -y`
}


# centos依赖安装，待完善
installMailboxDependenciesCentos(){
	echo "centos"	
}

# 配置发送方邮箱服务
configureMailbox(){	
	
	from=`awk -F '=' '/\[sendOutMailConf\]/{a=1}a==1&&$1~/set from/{print $2;exit}' $mailConif`
	setFrom="set from=$from"
	`sed -i "s/^.*set from.*$/$setFrom/" /etc/s-nail.rc`
	
	smtp=`awk -F '=' '/\[sendOutMailConf\]/{a=1}a==1&&$1~/set smtp/{print $2;exit}' $mailConif`
	setSmtp="set smtp=$smtp"
	`sed -i "s/^.*set smtp.*$/$smtp/" /etc/s-nail.rc`

	user=`awk -F '=' '/\[sendOutMailConf\]/{a=1}a==1&&$1~/set smtp-auth-user/{print $2;exit}' $mailConif`
	setUser="set smtp-auth-user=$user"
	`sed -i "s/^.*set smtp-auth-user.*$/$setUser/" /etc/s-nail.rc`

	password=`awk -F '=' '/\[sendOutMailConf\]/{a=1}a==1&&$1~/set smtp-auth-user/{print $2;exit}' $mailConif`
	setPass="set smtp-auth-password=$password"
	`sed -i "s/^.*set smtp-auth-password.*$/$setPass/" /etc/s-nail.rc`

	auth="set smtp-auth=login"
	`sed -i "s/^.*set smtp-auth.*$/$auth/" /etc/s-nail.rc`
}

# 单个发送邮箱测试
onlySendMailTest(){
	single_mailbox=`awk -F '"' '/\[recipientMailConf\]/{a=1}a==1&&$1~/single_mailbox/{print $2;exit}' $1`
	`bash $3/sendMail.sh $2 $single_mailbox`
}

# 单个邮箱发送提醒设置
onlySendMailSet(){
	`chmod 777 /var/spool/cron/crontabs/root`        
	isConf=`cat /var/spool/cron/crontabs/root | grep "only_mail"`
	only_mailbox=`awk -F '"' '/\[recipientMailConf\]/{a=1}a==1&&$1~/single_mailbox/{print $2;exit}' $1/remindMail.conf`	
	if [[ ! -n "$isConf" ]];then
		sed -ie '/only_mail.sh/d' /var/spool/cron/crontabs/root				
	fi						        
	time_num=`date -d "1 hour" +"%M"`
	echo "$time_num * * * $1/only_mail.sh" >> /var/spool/cron/crontabs/root
	`bash $1/sendMail.sh $2 $only_mailbox`
}
# 群发邮件测试
groupSendMailTest(){
	group_mailbox=`awk -F '"' '/\[recipientMailConf\]/{a=1}a==1&&$1~/group_mailbox/{print $2;exit}' $1`
	for i in $group_mailbox
	do
		`bash $3/sendMail.sh $2 $i`
	done
}

# 群发邮箱提醒设置
groupSendMailSet(){
	`chmod 777 /var/spool/cron/crontabs/root`
	isNull=`cat /var/spool/cron/crontabs/root | grep "group_mail.sh"`
	if [[ ! -n "$isConf" ]];then
		sed -ie '/group_mail.sh/d' /var/spool/cron/crontabs/root
	fi
	echo "30 8 * * * $1/group_mail.sh" >> /var/spool/cron/crontabs/root
}

# 开始执行
while [ 1 ]
do
	
	if [ 1 ];then	
		echo -e "\033[32m ########################### String ########################### \033[0m"
		# 功能选择
		format_check
		# 余额查询
		banles=`dfx wallet --network ic balance | awk -F' ' '{print $1}'`
		# 路径获取
		dir=`pwd`
		if [[ "$oper1" == "0" ]];then
			read -p "Please enter the path of the configuration file：" mailConf 
			if [[ "$LINUX_OS" == "Ubuntu" ]];then
				installMailboxDependenciesUbuntu
				configureMailbox
			elif [[ "$LINUX_OS" == "Centos" ]];then
				echo "centos"
			else
				echo -e "\033[31m Error:Your system doesn't match! {OS: Ubuntu or Centos} \033[0m"
				exit
			fi
		elif [[ "$oper1" == "1" ]];then
			read -p "Please enter the path of the configuration file：" mailConf
			onlySendMailTest $mailConf $banles $dir
		elif [[ "$oper1" == "2" ]];then
			sed -i "s/^.*banles.*$/banles=$banles/" $dir/balance.conf
			onlySendMailSet $dir $banles
		elif [[ "$oper1" == "3" ]];then
			read -p "Please enter the path of the configuration file：" mailConf
			groupSendMailTest $mailConf $banles $dir
		elif [[ "$oper1" == "4" ]];then
			read -p "Please enter the path of the configuration file：" mailConf
			`sed -i "s/^.*banles.*$/banles=$banles/" $dir/balance.conf`
			groupSendMailSet $dir
			echo -e "\033[36m It will be reminded at 8:30 every day \033[0m"			
		else                
			exit
		fi
		
	fi
	service cron restart
	echo -e "\033[32m ########################### Stop ########################### \033[0m"
	echo ""
done







未来一个月可实现前端自定阈值 提醒时间和发送邮箱
