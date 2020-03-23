#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.features/amzlnx2 ]
then
    echo "AmazonLiunx2 already configured."
    exit 0
fi

# ローカライズ設定を行う。
cat /home/vagrant/code/z_vagrant/etc/sysconfig/clock > /etc/sysconfig/clock
cat /home/vagrant/code/z_vagrant/etc/sysconfig/i18n > /etc/sysconfig/i18n
echo "Updated timezone and language."

grep -q "swapfile" /etc/fstab
if [ $? -ne 0 ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap defaults 0 0' >> /etc/fstab
fi
echo "Created swap."

# ロックファイルを作成する
touch /home/vagrant/.features/amzlnx2
chown -Rf vagrant:vagrant /home/vagrant/.amzlnx2
echo "Complete !!"