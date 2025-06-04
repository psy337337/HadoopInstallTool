

# Hadoop

# Hadoop 빠른 설치 가이드

## 1단계 - **환경 준비**

* Ubuntu 22.04 사용
* 필수 설치 패키지:
  * OpenJDK 11
  * OpenSSH
  * net-tools
  * sshpass
* 위 패키지들은 `install.sh` 스크립트를 통해 자동 설치할 수 있습니다 (사용을 권장합니다).

🔸 **NameNode**

* 공개키 인증을 **비밀번호 인증으로 변경**
* Git install
* Git clone

  * 스크립트 실행을 위한 Git 저장소 복제

🔸 **DataNode**

* 공개키 인증을 **비밀번호 인증으로 변경**
* Git install
* Git clone

  * 스크립트 실행을 위한 Git 저장소 복제
* ubuntu 사용자 비밀번호 설정


### ❗주의사항❗

1. **모든 DataNode에서 반드시** 공개키 인증을 비밀번호 인증으로 변경해야 합니다.
2. **모든 DataNode에서** `ubuntu` 계정 비밀번호를 설정해야 합니다.


## ▶ 실행

🔹 **NameNode**

```bash
sudo apt update

sudo apt install git -y
git clone https://github.com/psy337337/HadoopInstallTool.git
find ./HadoopInstallTool -type f -name '*.sh' -exec chmod +x {} \;
./HadoopInstallTool/install.sh

sudo sed -i "/PasswordAuthentication/ c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo systemctl restart sshd
```

🔹 **DataNode**

```bash
sudo apt update

sudo apt install git -y
git clone https://github.com/psy337337/HadoopInstallTool.git
find ./HadoopInstallTool -type f -name '*.sh' -exec chmod +x {} \;
./HadoopInstallTool/install.sh

sudo sed -i "/PasswordAuthentication/ c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo passwd ubuntu
```

`ubuntu` 계정의 비밀번호를 입력 (예: `ubuntu`)

## 2단계 - Hadoop 설치 및 시작 준비

**두 가지 버전**이 있으며, `sudo passwd ubuntu`로 설정된 비밀번호에 따라 선택합니다.

1. DataNode의 ubuntu 계정 비밀번호가 `ubuntu` **아닌 경우**
2. DataNode의 ubuntu 계정 비밀번호가 `ubuntu` **인 경우**


### ❗주의사항❗
1. IP 주소를 입력할 때 **입력 순서가 중요합니다.**

   * **NameNode IP를 제일 앞에 입력해야 합니다.**
   * 이후 노드들에 대해서는 비밀번호를 입력하지 않아도 됩니다 (`install_hadoop_v2.sh` 사용 시).

2. 2번 과정으로 설치를 진행한다면, **모든 노드가 동일한 비밀번호(`ubuntu`)를 사용해야 합니다.**

   * 하나라도 다르면 해당 노드와 연결되지 않습니다.



## ▶ 실행 방법

### 1. **DataNode 비밀번호가 `ubuntu`가 아닌 경우**

🔹 예시 (일반):

```bash
./HadoopInstallTool/install_hadoop_v1.sh (NameNode IP) (DataNode IP) (DataNode 비밀번호) (DataNode IP) (DataNode 비밀번호) ...
```

🔹 예시 (실제):

```bash
./HadoopInstallTool/install_hadoop_v1.sh 10.0.20.157 10.0.20.180 ubuntu 10.0.20.181 ubuntu2
```


### 2. **DataNode 비밀번호가 모두 `ubuntu`인 경우**

🔹 예시 (일반):

```bash
./HadoopInstallTool/install_hadoop_v2.sh (NameNode IP) (DataNode IP) (DataNode IP) ...
```

🔹 예시 (실제):

```bash
./HadoopInstallTool/install_hadoop_v2.sh 10.0.20.157 10.0.20.180 10.0.20.181
```


## 3단계 - Hadoop 시작

**NameNode의 hadoop 계정**에서 다음 명령어들을 실행하세요:

```bash
hdfs namenode -format

./hadoop/sbin/start-dfs.sh

./hadoop/sbin/start-yarn.sh
```


