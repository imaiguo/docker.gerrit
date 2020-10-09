#!/bin/bash
Project=gerrit
Version=3.2.3

repository=gerrit
tag=3.2.3

HTTP_PORT=8090
SSH_PORT=29000

#关闭镜像
docker_stop()
{
	echo "image $DCOKER_NAME $1 stop"
	DOCKER_PS=`docker ps | grep $1 | awk '{print $1}'`
	DOCKER_PS_A=`docker ps -a | grep $1 | awk '{print $1}'`
	if [ -n "$DOCKER_PS" ] ; then
		docker stop $DOCKER_PS
		echo "[$DOCKER_PS] docker stop success!"
	fi
	if [ -n "$DOCKER_PS_A" ]; then
		docker rm $DOCKER_PS_A
		echo "[$DOCKER_PS_A] docker rm success!"
	fi
	echo -e "docker $1 stop success!"
}


print_help()
{
  cat<< HELP
	parameter description:
	eg:sh start.sh 0
	----------------------------------------------
	-- 0    - help
	-- 1    - create & start gerrit container
	-- 2    - stop gerrit container
	-- 3    - start gerrit container
	-- 4    - init gerrit
	-- 5    - view running images
	-- 6    - view all images
	-- 7    - start service

	$Project current version:$Version
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


printBlankRow()
{
	echo -e "\n\n"
	exit 1
}

	

#关闭镜像
docker_stop()
{
	check_install
	echo "image $Project $1 stop"
	DOCKER_PS=`docker ps | grep $1 | awk '{print $1}'`
	DOCKER_PS_A=`docker ps -a | grep $1 | awk '{print $1}'`
	if [ -n "$DOCKER_PS" ] ; then
		docker stop $DOCKER_PS
		echo "[$DOCKER_PS] docker stop success!"
	fi
	if [ -n "$DOCKER_PS_A" ]; then
		docker rm $DOCKER_PS_A
		echo "[$DOCKER_PS_A] docker rm success!"
	fi
	echo -e "docker $1 stop success!"
}

run_proc()
{
	echo "now start program....."
    #docker exec -it ${Project}_${Version} bash /entrypoint.sh init

    docker exec -it ${Project}_${Version} bash -c "nginx; bash /var/gerrit/bin/gerrit.sh  run"
}

run_init()
{
	echo "now init....."
    docker exec -it ${Project}_${Version} bash /entrypoint.sh init
}


findtimezone()
{
	if [ ! -f "/etc/timezone" ]; then
		echo "Not find timezone."
		echo " please set timezone to [/etc/timezone]."
		exit -1
	else
		echo "find timezone."
	fi


	tzone=`cat /etc/timezone`
	if [ "${tzone}" != "" ];  then
		echo "Find timezone[${tzone}]"
	else
		echo "Timezone is NULL."
		echo " please set timezone to [/etc/timezone]."
		exit -1
	fi
}


create_start()
{
	findtimezone
	check_install
	params=""
	docker_stop ${Project}_${Version}

	if [ "${HTTP_PORT}" != "" ]; then
		params="${params} -p ${HTTP_PORT}:${HTTP_PORT}"
	fi

	if [ "${SSH_PORT}" != "" ]; then
		params="${params} -p ${SSH_PORT}:${SSH_PORT}"
	fi


	params="${params} --name ${Project}_${Version}"
	params="${params} --ulimit core=0"
	params="${params} --restart=always"
	params="${params} -v /etc/localtime:/etc/localtime:ro"
	params="${params} -v /etc/timezone:/etc/timezone:ro"

    params="${params} -v $(pwd)/data/sites-enabled:/etc/nginx/sites-enabled"	
    params="${params} -v $(pwd)/data/gerrit.password:/var/gerrit/gerrit.password:rw"	
    
    params="${params} -v $(pwd)/data/etc:/var/gerrit/etc"	
    params="${params} -v $(pwd)/data/cache:/var/gerrit/cache"
    params="${params} -v $(pwd)/data/git:/var/gerrit/git"
    params="${params} -v $(pwd)/data/index:/var/gerrit/index"

	echo "Starting ${Project} ${Version} container..."

	docker run -itd ${params} ${repository}:${tag} /bin/bash > /dev/null

	if [ $? -ne 0 ]; then
		echo "Run failed. Container maybe is running."
		exit 1
	fi

	container_id=`docker ps --filter ancestor=${repository}:$tag --format "{{.ID}}"`
	if [ "${container_id}" == "" ]; then
		echo "Error: Start container failed!"
		echo "Exit."
		exit 1
	fi

	echo "container_id:[${container_id}]"
	echo .
	
	#run_proc
	echo "Start ${Project} ${Version} successd."
}

#shell start
case $1 in
	0)
		print_help && printBlankRow
		;;
	1)
		create_start && printBlankRow
		;;
	2)
		docker stop ${Project}_${Version} && printBlankRow
		;;
	3)
		docker start ${Project}_${Version} && printBlankRow
		;;
	4)
		run_init
		;;
	5)
		docker ps && printBlankRow
		;;
	6)
		docker ps -a && printBlankRow
		;;
    7)
        run_proc
        ;;

	*)
		print_help && printBlankRow
		;;
esac


		
		
		
