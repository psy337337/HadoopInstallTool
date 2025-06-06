#!/bin/bash


# install hadoop & make symbolic link
cd /home/hadoop
wget https://downloads.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz
tar xzf hadoop-3.4.1.tar.gz
ln -s /home/hadoop/hadoop-3.4.1 ~/hadoop;

# Setting hadoop's environment variables
cat ./HadoopInstallTool/config_templates/bashrc.txt >> /home/hadoop/.bashrc
source ~/.bashrc

mkdir ~/hadoop/logs
