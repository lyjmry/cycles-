#!/bin/bash
# 从配置文件获取多个邮箱
group_mailbox=`awk -F '"' '/\[recipientMailConf\]/{a=1}a==1&&$1~/group_mailbox/{print $2;exit}' ./remindMail.conf`
# 查询最新余额
banles=`dfx wallet --network ic balance | awk -F' ' '{print $1}'`
# 从配置文件获取配置文件路径
dir=`awk -F '"' '/\[recipientMailConf\]/{a=1}a==1&&$1~/dir/{print $2;exit}' ./remindMail.conf`
# 群发执行
for i in $group_mailbox
do
	`bash $dir/sendMail.sh $banles $single_mailbox`
done
