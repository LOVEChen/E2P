#!/bin/bash
#***************************************************
#脚本：E2P(Email 2 Post)
#编写：zjhou
#日期：2015-11-12
#更新：2015-11-12
#描述：解析博客管理员的邮件，自动部署，或删除，更改
#      博客系统完成博客管理更新工作。
#
#功能：1. 部署文章
#      2. 删除文章
#      3. 更改文章
#      4. 查询博博客信息
#
#备注：该脚本作为mail客户端的钩子，将被自动调用。
#***************************************************

global_vars() {
	
	global_white_list=("wintrace@outlook.com" "313721293@qq.com")		
		
		
}

#*工具函数*
#如果待匹配的用户在白名单中则返回真，否则返回假
#------+------------------
# 参数 | 描述
#------+------------------
# $1   | 待匹配的用户
#------+------------------
match_white_list() {
	for user in ${global_white_list[@]}; do
		if [ "$1" == "$user" ]
		then 
			#注意！0表示匹配成功。
			return 0
		fi
	done
	return 1
}

#*工具函数*
#检查邮件发送者是否在白名单中，如果在，返回其邮件编号。为真。
#如果不在返回假。
#-----------+--------------------------
#    返回值 | 描述
#-----------+--------------------------
#     1     | 检测失败，无管理员邮件
#-----------+--------------------------
#     0     | 检测成功，有管理员邮件
#-----------+--------------------------
# $(($i+1)) | 管理员邮件的序号
#-----------+--------------------------
check_sender() {
	#通过在配置文件~/.mailrc或/etc/nail.rc中设置headline的值
	#可以控制mail -H的输出字段。
	#这里headline的值为"%m %30s %s"
	#第一个字段的值是邮件序号。
	#第二个字段的值是发件人的地址。
	#第三个字段的值是邮件主题。
	local user=(`mail -H | awk '{print $2}'`)
	local len=${#user[@]}
	for ((i = 0; i < $len; i++)); do
		match_white_list ${user[$i]} && echo $(($i+1)) && return 0
	done
	return 1
}


#****主函数****
#为了程序可读性，封装了该脚本里其他函数
MAIN (){
	global_vars
	emailNum=`check_sender`
	echo $emailNum
}

#***************************************************
#请勿改动此部分内容。*******************************
#如果要修改，修改MAIN()函数。***********************
MAIN #**********************************************
#***************************************************
