#!/bin/bash

. /etc/os-release

#check os
if [ "$NAME" != "Ubuntu" ]; then
    echo "This script is for Ubuntu."
    exit
fi

# update repo JAVA, ssh, net-tools, sshpass 
sudo apt-get update
if [ ! -x "$(command -v java)" ]; then
    # install java
    sudo apt-get -y install openjdk-11-jdk

    # add JAVA_HOME
    echo >> /home/$USER/.bashrc
    echo "export JAVA_HOME=\$(readlink -f /usr/bin/java | sed 's:bin/java::')" >> /home/$USER/.bashrc
else
    echo "Found Java, skipping the installation of Java."
fi
if [ "$(which ssh)" == "" ]; then
    sudo apt install openssh-server -y
    sudo apt install openssh-client -y
fi
if [ "$(which sshpass)" == "" ]; then
    sudo apt-get install sshpass -y
fi
if [ "$(which netstat)" == "" ]; then
    sudo apt install net-tools -y
fi


