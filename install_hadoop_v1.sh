#!/bin/bash

if [ $# -eq 0 ];then
    echo "Please Input ip address"
    exit 0
fi

./HadoopInstallTool/script/hostset.sh $@
./HadoopInstallTool/script/makeUser.sh

sudo -S bash -c 'echo "hadoop ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/hadoop && chmod 440 /etc/sudoers.d/hadoop'

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
    # sshpass -p $i ssh ubuntu@$address -o StrictHostKeyChecking=no "echo $i | sudo -S apt-get install -y git" 
    # sshpass -p $i ssh ubuntu@$address -o StrictHostKeyChecking=no "git clone https://github.com/psy337337/HadoopInstallTool.git && \
    
                                                                                    # echo $i | sudo -S chmod +x ./HadoopInstallTool/script/*.sh && \
    sshpass -p $i ssh ubuntu@$address -o StrictHostKeyChecking=no "echo $i | sudo -S ./HadoopInstallTool/script/hostset.sh $@ && \
                                                                                    echo $i | sudo -S ./HadoopInstallTool/script/makeUser.sh && \
        echo $i | sudo -S bash -c 'echo \"hadoop ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/hadoop && chmod 440 /etc/sudoers.d/hadoop'"
    # sshpass -p $i ssh ubuntu@$address -o StrictHostKeyChecking=no "echo $i | sudo ./HadoopInstallTool/script/install.sh" 
done

sshpass -p hadoop ssh hadoop@hdn -o StrictHostKeyChecking=no -t "cd; git clone https://github.com/psy337337/HadoopInstallTool.git &&\
                        echo hadoop | sudo -S chmod +x ./HadoopInstallTool/script/*.sh &&\
                        echo hadoop | sudo -S ./HadoopInstallTool/script/connect.sh"



num=0
for i in $@
do
	num=$(($num+1))
	if [ "$(($num%2))" == "1" ]; then
		continue
	fi
	sshpass -p hadoop ssh hadoop@$i -o StrictHostKeyChecking=no -t "cd; \
    git clone https://github.com/psy337337/HadoopInstallTool.git; \
    echo hadoop | sudo -S chmod +x ./HadoopInstallTool/script/*.sh; \
    echo hadoop | sudo -S ./HadoopInstallTool/script/connect.sh"
done



echo "hadoop" | su - hadoop -c "cd; ./HadoopInstallTool/script/installHadoop.sh; source ~/.bashrc;"

./HadoopInstallTool/script/inputProfile.sh

sshpass -p hadoop ssh hadoop@hdn -o StrictHostKeyChecking=no -t "cd ~; pwd; source ~/.bashrc; ./HadoopInstallTool/script/setHadoop.sh"
