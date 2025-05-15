#!/bin/bash

# ChatGPT 사용하여 아래 스크립트 작성

# 기존 hdn, hdw* 관련 항목 삭제
sudo sed -i '/\thdn$/d' /etc/hosts
sudo sed -i '/\thdw[0-9]\+$/d' /etc/hosts

# 인자 수 확인
if [ $# -lt 1 ]; then
    echo "사용법: $0 <마스터 IP> [워커 IP1] [불필요한 인자] [워커 IP2] [불필요한 인자] ..."
    exit 1
fi

# 혹시몰라 백업 생성
sudo cp /etc/hosts /etc/hosts.bak.$(date +%Y%m%d%H%M%S)

# 마스터 노드 등록
echo "$1 hdn" | sudo tee -a /etc/hosts

# 워커 노드 등록 (2번째 인자부터 시작, 홀수 인덱스만 처리)
worker_count=1
for ((i = 1; i < $#; i += 2)); do
    ip="${!((i + 1))}"
    if [ -n "$ip" ]; then
        echo "$ip hdw$worker_count" | sudo tee -a /etc/hosts
        ((worker_count++))
    fi
done
