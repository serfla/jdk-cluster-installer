#!/bin/bash

USER=''
JDK_FOLDER=''
HOSTS=()
JDK_INSTALLER_NAME="set-jdk-as-default.sh"
ERR_MSG="Please try sudo ./DMASON-cluser-installer.sh -u username -j JDK_FOLDER -h \"node1 node2 ....\""
#if [ "$(id -u)" -ne 0 ]; then
#	echo "You have to run this script as root"
#	echo $ERR_MSG
#	exit 1
#fi

while getopts "u:j:h:" opt ; do
		
	case $opt in
		j) 
			#check if the arg is a directory and it exists 
			if [[ ! -e "$OPTARG" || ! -d "$OPTARG" ]]; then
				echo "$OPTARG is not a directory!"
				echo $ERR_MSG
				exit 1;
			else
   				echo "Do you want to use $OPTARG as jdk? Y/N";
				confirm=""
				while [[ $confirm != "n" && $confirm != "N" && $confirm != "y" && $confirm != "Y" ]]; do
				    read confirm
				    if [[ $confirm = "y" || $confirm = "Y" ]]; then
						if [ "$OPTARG" == "*/" ]; then
							JDK_FOLDER=${OPTARG:0:${#OPTARG}-1}
						else
       						JDK_FOLDER="$OPTARG";
						fi
				    else
				    	echo "Aborting....."
				    	exit 0;	
				    fi
				done
			fi
			;;
		h)
			
			#split the node list into array if it is not empty
			if [ -n "$OPTARG" ];then
				HOSTS=$(echo $OPTARG | tr " " "\n")
			else
				echo "Invalid node list!"
				echo $ERR_MSG
				exit 1;
			fi
			;;
		\?)
			echo "Invalid option -$OPTARG"
			exit 2
			;;

		:)
			case $OPTARG in
			 	j)
					echo "The -$OPTARG option requires the jdk directory to install"
					exit 2
					;;
				h)
					echo "The -$OPTARG option requires the quoted node list"
					echo "E.g. -h \"node1 node2 node3 .....\""
					exit 2
					;;
			esac
			;;
	esac
done

if [ ! -e $JDK_INSTALLER_NAME  ]; then
	echo "Missing file $JDK_INSTALLER_NAME"
	echo "Please check if you have missed it while copying"
	exit -1
fi
		
#We want to be sure which JDK_FOLDER is set
if [ -z "$JDK_FOLDER"  ]; then
	echo "Something was wrong! Try again..."
	echo $ERR_MSG
	exit -1
fi


#Copying JDK_FOLDER on cluster nodes in home directory by ssh
for host in ${HOSTS[@]}; do
	echo "Start copy $JDK_FOLDER on $host"
	scp -r $JDK_FOLDER $JDK_INSTALLER_NAME $host:.  
	wait
done	

for host in ${HOSTS[@]}; do
	echo "Start copy $JDK_FOLDER on $host"
	ssh $host -t "sudo ./set-jdk-as-default.sh $JDK_FOLDER"
	wait
done	
