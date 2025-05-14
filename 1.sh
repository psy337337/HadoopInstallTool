#!/bin/bash

if [ $# -eq 0 ];then
    echo "Please Input ip address"
    exit 0
fi

./HadoopInstallTool/hostset.sh $@
./HadoopInstallTool/makeUser.sh

#first time can't used sshpass

num=0
address=""
for i in $@
do
    num=$(($num+1))
    if [ "$(($num%2))" == "0" ]; then
        address=$i
	continue
    elif [ "$num" == "1" ]; then
        continue
    fi
    sshpass -p $i ssh ubuntu@$address -o StrictHostKeyChecking=no "echo ubuntu | sudo -S apt-get install -y git" 
    sshpass -p $i ssh ubuntu@$address -o StrictHostKeyChecking=no "git clone https://github.com/psy337337/HadoopInstallTool.git; chmod +x ./HadoopInstallTool/*.sh; ./HadoopInstallTool/hostset.sh $@; ./HadoopInstallTool/makeUser.sh"
done

# sshpass -p hadoop ssh hadoop@hdn -o StrictHostKeyChecking=no -t
sshpass -p hadoop ssh hadoop@hdn -o StrictHostKeyChecking=no -t "cd; git clone https://github.com/psy337337/HadoopInstallTool.git; chmod +x ./HadoopInstallTool/*.sh; ./HadoopInstallTool/connect.sh"



num=0
for i in $@
do
	num=$(($num+1))
	if [ "$(($num%2))" == "1" ]; then
		continue
	fi
	sshpass -p hadoop ssh hadoop@$i -o StrictHostKeyChecking=no -t "cd; \
    git clone https://github.com/psy337337/HadoopInstallTool.git; \
    chmod +x ./HadoopInstallTool/*.sh; ./HadoopInstallTool/connect.sh"
done



echo "hadoop" | su - hadoop -c "cd; ./HadoopInstallTool/installHadoop.sh; source ~/.bashrc;"

./HadoopInstallTool/inputProfile.sh

sshpass -p hadoop ssh hadoop@hdn -o StrictHostKeyChecking=no -t "cd ~; pwd; source ~/.bashrc; ./HadoopInstallTool/setHadoop.sh"
