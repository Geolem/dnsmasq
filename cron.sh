#!/bin/sh
CRON_FILE=/etc/crontabs/$USER
grep "dnsmasq" $CRON_FILE >/dev/null
if [ ! $? -eq 0 ]; then
	echo -e "\e[1;31m 添加规则自动更新计划任务\e[0m"
	if [ -f /etc/crontabs/Update_time.conf ]; then
		timedata=$(cat /etc/crontabs/Update_time.conf)
		else
		timedata='5'
	fi	
	if [ -f /etc/dnsmasq/ad_update.sh ]; then
		echo "# 每天$timedata点25分更新广告规则
25 $timedata * * * sh /etc/dnsmasq/ad_update.sh > /dev/null 2>&1" >> $CRON_FILE
	elif [ -f /etc/dnsmasq/fqad_update.sh ]; then
		echo "# 每天$timedata点25分更新翻墙和广告规则
25 $timedata * * * sh /etc/dnsmasq/fqad_update.sh > /dev/null 2>&1" >> $CRON_FILE
	elif [ -f /etc/dnsmasq/fqad_update.sh ]; then
		echo "# 每天$timedata点25分更新翻墙规则
25 $timedata * * * sh /etc/dnsmasq/fq_update.sh > /dev/null 2>&1" >> $CRON_FILE
	fi
	/etc/init.d/cron reload
	echo
	echo -e "\e[1;36m 自动更新任务添加完成\e[0m"
	echo
fi
sleep 3
grep "reboot" $CRON_FILE >/dev/null
if [ ! $? -eq 0 ]; then
	if [ -f /etc/crontabs/reboottime.conf ]; then
		reboottime=$(cat /etc/crontabs/reboottime.conf)
		else
		reboottime='6'
	fi	
	echo -e "\e[1;36m 设置路由器定时重启\e[0m"
	echo "# 每天$reboottime点05分重启路由器
04 $reboottime * * * sleep 1m && touch /etc/banner && reboot" >> $CRON_FILE
	/etc/init.d/cron reload
	echo
	echo -e "\e[1;36m 定时重启任务设定完成\e[0m"
	echo
fi