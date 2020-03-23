#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.homestead-features/minio-client ]
then
    echo "Minio-client already installed."
    exit 0
fi

# minioクライアントをインストールする
curl -sO https://dl.minio.io/client/mc/release/linux-amd64/mc
chmod +x mc
mv mc /usr/local/bin
echo "Installed minio-client"

/usr/local/bin/mc config host add vagrant http://192.168.100.100:9600 vagrant secretkey
echo "Updated minio-client configuration."

# ロックファイルを作成する
touch /home/vagrant/.features/minio-client
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"