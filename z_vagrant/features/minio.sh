#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.homestead-features/minio ]
then
    echo "Minio already installed."
    exit 0
fi

# minioをインストールする
curl -sO https://dl.minio.io/server/minio/release/linux-amd64/minio
chmod +x minio
mv minio /usr/local/bin
echo "Installed minio"

# 実行ユーザーを使いする。
useradd -r minio-user -s /sbin/nologin
echo "Created minio-user."

# 実行に必要なディレクトリを作成する。
mkdir /usr/local/share/minio
mkdir /etc/minio
chown minio-user:minio-user /usr/local/share/minio
chown minio-user:minio-user /etc/minio
echo "Created working directories."

# 設定ファイルを作成する。
cat /home/vagrant/code/z_vagrant/etc/default/minio >> /etc/default/minio
echo "Created /etc/default/minio"

# minioをサービスとして登録する
curl -sO https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service
mv minio.service /etc/systemd/system
systemctl daemon-reload
echo "Registered /etc/systemd/system/minio.service"

# 自動起動設定を入れる
systemctl enable minio
echo "Enabled auto start."

# 起動する
systemctl start minio
echo "Started minio"

# minioクライアントをインストールする
curl -sO https://dl.minio.io/client/mc/release/linux-amd64/mc
chmod +x mc
mv mc /usr/local/bin
echo "Installed minio-client"

# 設定を追加する。
/usr/local/bin/mc config host add admin http://127.0.1.1:9600 vagrant secretkey
echo "Updated minio-client configuration."

# バケットを作成する。
/usr/local/bin/mc mb /usr/local/share/minio/vagrant
/usr/local/bin/mc policy set public /usr/local/share/minio/vagrant
echo "Created default buckets."

# ロックファイルを作成する
touch /home/vagrant/.features/minio
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"