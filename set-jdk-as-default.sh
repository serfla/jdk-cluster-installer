#!/bin/bash

JDK_FOLDER=''
ERR_MSG="Please try sudo ./set-jdk-as-default.sh JDK_FOLDER"

if [ "$(id -u)" -ne 0 ]; then
	echo "You have to run this script as root"
	exit -1
fi

if [ -z "$1" ]; then
	echo "Invalid JDK folder!"
	echo $ERR_MSG
	exit -1
fi

JDK_FOLDER="$1"

mkdir -p /usr/lib/jvm/

cp -r $JDK_FOLDER /usr/lib/jvm

JDK_HOME="/usr/lib/jvm/$JDK_FOLDER"

# Set java commands in /usr/bin

update-alternatives --install "/usr/bin/java" "java" "$JDK_HOME/bin/java" 1 
update-alternatives --set "java" "$JDK_HOME/bin/java" 
update-alternatives --install "/usr/bin/javac" "javac" "$JDK_HOME/bin/javac" 1 
update-alternatives --set "javac" "$JDK_HOME/bin/javac"
update-alternatives --install "/usr/bin/javaws" "javaws" "$JDK_HOME/javaws" 1 
update-alternatives --set "javaws" "$JDK_HOME/bin/javaws"



