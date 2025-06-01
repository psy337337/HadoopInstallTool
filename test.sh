#!/bin/bash

lists=("core-site" "hdfs-site" "mapred-site" "yarn-site")

for i in "${lists[@]}"
do
        sed -i "/configuration>/d" ./hadoop/etc/hadoop/${i}.xml
        cat ./HadoopInstallTool/config_templates/${i}.txt >> ./hadoop/etc/hadoop/${i}.xml
done
sed -i "s/127.0.0.1/$(hostname -I | sed -e 's/  *$//')/g" ./hadoop/etc/hadoop/core-site.xml
sed -i "s/0.0.0.0/$(hostname -I | sed -e 's/  *$//')/g" ./hadoop/etc/hadoop/yarn-site.xml



linecnt=$(sed -n '/hd/p' /etc/hosts | wc -l)
for ((i=1; i<$linecnt; i++))
do
        scp -r -o StrictHostKeyChecking=no /home/hadoop/* hadoop@hdw$i:/home/hadoop/
done

