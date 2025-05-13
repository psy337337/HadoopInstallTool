#!/bin/bash

cat ./HadoopInstallTool/profile.txt | sudo tee -a /etc/profile
source /etc/profile
