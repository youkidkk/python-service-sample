#!/bin/bash
cd $(cd $(dirname $0);pwd)/..

# 変数設定
## 共通
service_dir=/etc/systemd/system
## プロジェクト固有
service_name=python-service-sample
service_file=$service_name.service

sudo systemctl stop $service_name.service
sudo systemctl disable $service_name.service
sudo rm $service_dir/$service_file

if [ $? -ne 0 ]; then
  echo "サービスを削除できませんでした。 $service_name"
  exit 1
fi

echo "サービスを削除しました。 $service_name"
exit 0
