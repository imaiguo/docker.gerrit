#!/bin/bash

APPP_NAME=gerrit
APPP_VERSION=3.2.3


#帮助说明
print_help()
{
  cat<< HELP
	parameter description:
	eg:sh start.sh 0
	----------------------------------------------
	-- 0	- help
	-- 1	- load gerrit image
	$APPP_NAME current version:[$APPP_VERSION]
HELP
}


#检查初始化环境
check_install()
{
	if [[ ! -f `which docker` ]]; then
		echo -e "Please initialize the docker environment! [ sh start.sh 1]"
		echo -e ""
		printBlankRow
	fi
	
	if [[ `id -u`  -eq 0 ]]  && [[ $USER != "root" ]];then
		echo -e "Please use user:[$USER]"
		echo -e "1.exit"
		printBlankRow
	fi
}

#装载镜像
image_load(){
	check_install
	IMAGE_ALREADY=`docker images | grep $1 |grep $2`
	if [ -n "$IMAGE_ALREADY" ];	then
		echo $IMAGE_ALREADY
		echo "$1 image already import !"
	else
		echo "$1 image import start..."
		IMAGE_ID=`docker import ./$1.$2.tar $1:$2 `
		if [ -n "${IMAGE_ID}" ]; then
			tmp=`echo $IMAGE_ID | cut -d : -f 2`
			echo -e "$1 image load success! ID[$tmp]"

		else
			echo -e "load $1 image failed! "
			printBlankRow
		fi
	fi
}


printBlankRow()
{
	echo -e "\n\n"
	exit 0
}

#shell start
case $1 in
	0)
		print_help && printBlankRow
		;;
	1)
		image_load $APPP_NAME $APPP_VERSION && printBlankRow
		;;
	*)
		print_help && printBlankRow
		;;
esac




