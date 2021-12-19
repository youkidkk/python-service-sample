#!/bin/bash
cd $(cd $(dirname $0);pwd)/..

# 変数設定
## 共通
user_name=$(whoami)
project_dir=$(pwd)
service_dir=/etc/systemd/system
tmp_file=./tmp/.tmpfile
## プロジェクト固有
service_name=python-service-sample
service_file=$service_name.service
service_description="Python service sample."
source_path=./src/python_service_sample.py

echo "サービスを登録します。"
echo "  名前: $service_name"
echo "  説明: $service_description"

# サービスファイル作成
cat <<EOF > $tmp_file
[Unit]
Description=$service_description

[Service]
User=$user_name
WorkingDirectory=$project_dir
ExecStart=/home/$user_name/.local/bin/pipenv run python3 $source_path
Restart=always
Type=simple

[Install]
WantedBy=multi-user.target
EOF

if [ $? -ne 0 ]; then
  echo "サービスファイルの作成に失敗しました。 $tmp_file"
  exit 1
fi
echo "サービスファイルを作成しました。 $tmp_file"

# サービスファイル移動
sudo mv $tmp_file $service_dir/$service_file
if [ $? -ne 0 ]; then
  echo "サービスファイルの移動に失敗しました。 $service_dir/$service_file"
  rm $tmp_file
  exit 1
fi
echo "サービスファイルを移動しました。 $service_dir/$service_file."

# サービスファイル所有者変更
sudo chown root:root $service_dir/$service_file
if [ $? -ne 0 ]; then
  echo "サービスファイルの所有者を変更できませんでした。 $service_dir/$service_file"
  exit 1
fi
echo "サービスファイルの所有者を変更しました。 $service_dir/$service_file."

# サービス登録
sudo systemctl enable $service_name
echo "サービスを登録しました。 $service_name"
exit 0
