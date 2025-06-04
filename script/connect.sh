#!/bin/bash

cd /home/hadoop

# SSH 키 생성
HOME_DIR=/home/hadoop
mkdir -p $HOME_DIR/.ssh
ssh-keygen -t rsa -f $HOME_DIR/.ssh/id_rsa -q -N ""
cat $HOME_DIR/.ssh/id_rsa.pub >> $HOME_DIR/.ssh/authorized_keys
chmod 700 $HOME_DIR/.ssh
chmod 600 $HOME_DIR/.ssh/authorized_keys
chown -R hadoop:hadoop $HOME_DIR/.ssh


# 자기 자신의 IP 주소 구함
MY_IP=$(hostname -I | awk '{print $1}')

# /etc/hosts에서 hd로 시작하는 호스트들의 IP만 추출
for ip in $(awk '/hd/ {print $1}' /etc/hosts); do
    # 자기 자신이면 건너뜀
    if [[ "$ip" == "$MY_IP" ]]; then
        continue
    fi

    echo "🔧 Preparing remote $ip for SSH key setup..."

    # .ssh 디렉토리가 없을 경우 원격 서버에서 생성
    sshpass -p hadoop ssh -o StrictHostKeyChecking=no hadoop@$ip "
        mkdir -p ~/.ssh && chmod 700 ~/.ssh && touch ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys
    "
    echo "Trying ssh-copy-id to $ip ..."
    # SSH 키 복사
    sshpass -p hadoop ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@$ip \
        && echo "!!✅ Success for $ip" \
        || echo "!!❌ Failed for $ip"
done


# cd /home/hadoop
# ssh-keygen -t rsa
# cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
# chmod 0600 ~/.ssh/authorized_keys

# cnt=0
# for i in $(sed -n '/hd/p' /etc/hosts)
# do
# 	cnt=$(($cnt+1))
# 	if [[ "${i} " == *"$(hostname -I)"* ]] || [ $(($cnt%2)) == 0 ];then
# 		continue
# 	fi
# 	sshpass -p hadoop ssh-copy-id -i /home/hadoop/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@$i
# done
