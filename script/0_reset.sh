# 기존 hdn, hdw* 관련 항목 삭제
sudo sed -i '/\thdn$/d' /etc/hosts
sudo sed -i '/\thdw[0-9]\+$/d' /etc/hosts

# 유저 삭제
a=$(cat /etc/passwd | grep hadoop)
if [ "$a" != "" ]; then
	sudo userdel -rf hadoop
fi