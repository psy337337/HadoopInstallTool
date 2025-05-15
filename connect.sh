#!/bin/bash

cd /home/hadoop

# SSH 키 생성
ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N ""
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chown -R hadoop:hadoop ~/.ssh

# 자기 자신의 IP 주소 구함
MY_IP=$(hostname -I | awk '{print $1}')

# /etc/hosts에서 hd로 시작하는 호스트들의 IP만 추출
for ip in $(awk '/hd/ {print $1}' /etc/hosts); do
    # 자기 자신이면 건너뜀
    if [[ "$ip" == "$MY_IP" ]]; then
        continue
    fi

    echo "Trying ssh-copy-id to $ip ..."
    sshpass -p hadoop ssh-copy-id -i ~/.ssh/id_rsa.pub -o StrictHostKeyChecking=no hadoop@$ip || echo "❌ Failed for $ip"
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
