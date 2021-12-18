#!/bin/bash
# 从配置文件获取单个邮箱
only_mailbox=`awk -F '"' '/\[recipientMailConf\]/{a=1}a==1&&$1~/single_mailbox/{print $2;exit}' ./remindMail.conf`
# 查询最新余额
banles=`dfx wallet --network ic balance | awk -F' ' '{print $1}'`
# 从配置文件获取路径
dir=`awk -F '"' '/\[recipientMailConf\]/{a=1}a==1&&$1~/dir/{print $2;exit}' ./remindMail.conf`
# 小于阈值执行提醒
if [[ "$banles" -le "$threshold" ]];then
	`bash $dir/sendMail.sh $banles $only_mailbox`
fi
