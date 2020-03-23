#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.features/apache ]
then
    echo "Apache already installed."
    exit 0
fi

# apacheのインストール
yum install -y httpd
echo "Installed Apache"

# confファイルを修正する
cat /home/vagrant/code/z_vagrant/etc/httpd/conf/httpd.conf > /etc/httpd/conf/httpd.conf
echo "Updated /etc/httpd/conf/httpd.conf"

# ユーザー定義のconfファイルを配置する
find ${1} -name '*.conf' -mindepth 1 -maxdepth 1 -print0 | while read -d $'\0' file; do
    cp ${file} /etc/httpd/conf.d/
done
echo "Created /etc/httpd/conf.d/*.conf"

# 自動起動設定を入れる
systemctl enable httpd
echo "Enabled auto start."

# 起動する
systemctl start httpd
echo "Started Apache"

# ロックファイルを作成する
touch /home/vagrant/.features/apache
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"