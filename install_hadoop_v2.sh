#!/bin/bash

if [ $# -eq 0 ];then
    echo "Please Input ip address"
    exit 0
fi

all=""
num=0
for i in $@
do
    num=$(($num+1))
    if [ "$num" == "1" ]; then
        all+="${i} "
        continue
    fi
    all+="${i} ubuntu "
done
# remove space
all=${all::-1}

./HadoopInstallTool/script/hostset.sh $all
./HadoopInstallTool/script/makeUser.sh

num=0
passwd="ubuntu"
for i in $@
do
    if [ "$num" == "0" ]; then
        num=$(($num+1))
        continue
    fi
    sshpass -p $passwd ssh ubuntu@$i -o StrictHostKeyChecking=no "echo ubuntu | sudo -S apt-get install -y git"
    sshpass -p $passwd ssh ubuntu@$i -o StrictHostKeyChecking=no "git clone https://github.com/psy337337/HadoopInstallTool.git; chmod +x ./HadoopInstallTool/script/*.sh; ./HadoopInstallTool/script/hostset.sh $all; ./HadoopInstallTool/script/makeUser.sh"
done


# connect NameNode
sshpass -p hadoop ssh hadoop@hdn -o StrictHostKeyChecking=no -t "cd; git clone https://github.com/psy337337/HadoopInstallTool.git; chmod +x ./HadoopInstallTool/script/*.sh; ./HadoopInstallTool/script/connect.sh"


# connect DataNode
num=0
for i in $@
do
    if [ "$num" == "0" ]; then
        num=$(($num+1))
        continue
    fi
    sshpass -p hadoop ssh hadoop@$i -o StrictHostKeyChecking=no -t "cd;\
    git clone https://github.com/psy337337/HadoopInstallTool.git; \
    chmod +x ./HadoopInstallTool/script/*.sh; \
    ./HadoopInstallTool/script/connect.sh"
done



echo "hadoop" | su - hadoop -c "cd; ./HadoopInstallTool/script/installHadoop.sh; source ~/.bashrc;"

./HadoopInstallTool/script/inputProfile.sh

sshpass -p hadoop ssh hadoop@hdn -o StrictHostKeyChecking=no -t "cd ~; pwd; source ~/.bashrc; ./HadoopInstallTool/script/setHadoop.sh"
