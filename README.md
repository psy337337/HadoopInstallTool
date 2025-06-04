# Hadoop 

# Quick install Hadoop

## Step 1 - **Environmental Preparation**

- ubuntu 22.04
- Packages that must be installed
    - OpenJDK 11
    - OpenSSH
    - net-tools
    - sshpass
- You can install packages automatically using `install.sh` if you want (I recommend using it.)

🔸**NameNode**

- Change public key authentication to password-based authentication
- git install
- git clone
    - Git clone for Script Execution

🔸**DataNode**

- Change public key authentication to password-based authentication
- git install
- git clone
    - Git clone for Script Execution
- ubuntu passwd
    - Ubuntu Account Password Settings

### ❗****Caution****❗

1. Proceed on **all DataNode’s** unconditionally changing public key authentication to password-based authentication
2. **All DataNode’s** ubuntu account set passwords

### ▶**Execute**

🔹NameNode

```java
sudo apt update

sudo apt install git -y
git clone https://github.com/psy337337/HadoopInstallTool.git
find ./HadoopInstallTool -type f -name '*.sh' -exec chmod +x {} \;
./HadoopInstallTool/install.sh


sudo sed -i "/PasswordAuthentication/ c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo systemctl restart sshd
```

🔹DataNode

```java
sudo apt update

sudo apt install git -y
git clone https://github.com/psy337337/HadoopInstallTool.git
find ./HadoopInstallTool -type f -name '*.sh' -exec chmod +x {} \;
./HadoopInstallTool/install.sh

sudo sed -i "/PasswordAuthentication/ c\PasswordAuthentication yes" /etc/ssh/sshd_config
sudo systemctl restart sshd

sudo passwd ubuntu
```

Input the Ubuntu password you want `ex. ubuntu`

## Step 2 - Install Hadoop & Preparing for Hadoop Start

**2 versions - (password set by sudo passwdu ubuntu)**

1. DataNode's ubuntu account **password is not `ubuntu`**
2. DataNode's ubuntu account **password is `ubuntu`**

### ❗****Caution****❗

1. When executing the account password ubuntu, the password for **all DataNodes must be `ubuntu`.**
    - If even one node is different, that node cannot be connected
2. **The order** in which the ip addresses are inputed is important
    - You have to **start with NameNode.**
    - You don't have to input the password after NameNode.

### ▶**Execute**

1. **DataNode's ubuntu account password is not `ubuntu`**
    
    🔹General Example
    
    ```java
    ./HadoopInstallTool/install_hadoop_v1.sh (NameNode's ip address) (DataNode's ip address) (DataNode's ubuntu passwd) (DataNode's ip address) (DataNode's ubuntu passwd)...
    ```
    
    🔹Real Example
    
    ```java
    ./HadoopInstallTool/install_hadoop_v1.sh 10.0.20.157 10.0.20.180 ubuntu 10.0.20.181 ubuntu2
    ```
    
2. **DataNode's ubuntu account password is `ubuntu`**
    
    🔹General Example
    
    ```java
    ./HadoopInstallTool/install_hadoop_v2.sh (NameNode's ip address) (DataNode's ip address) (DataNode's ip address)...
    ```
    
    🔹Real Example
    
    ```java
    ./HadoopInstallTool/install_hadoop_v2.sh 10.0.20.157 10.0.20.180 10.0.20.181
    ```
    

## Step 3 - Starting Hadoop

You just have to enter the following command in **NameNode’s hadoop account**

`hdfs namenode -format`

`./hadoop/sbin/start-dfs.sh`

`./hadoop/sbin/start-yarn.sh`
