#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.features/redis ]
then
    echo "Redis already installed."
    exit 0
fi

# Redisをインストールする
amazon-linux-extras install -y redis4.0
echo "Installed redis"

# 自動起動設定を入れる
systemctl enable redis
echo "Enabled auto start."

# confファイルを修正する
cat /home/vagrant/code/z_vagrant/etc/redis.conf > /etc/redis.conf
echo "Updated /etc/redis.conf"

# 起動する
systemctl start redis
echo "Started redis-server"

# ロックファイルを作成する
touch /home/vagrant/.features/redis
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"
