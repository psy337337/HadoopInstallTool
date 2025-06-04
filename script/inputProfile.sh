#!/bin/bash

cat ./HadoopInstallTool/config_templates/profile.txt | sudo tee -a /etc/profile
source /etc/profile
