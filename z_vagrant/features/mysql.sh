#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.features/mysql ]
then
    echo "Mysql already installed."
    exit 0
fi

# Mysqlをインストールする
#   Amazon Liunx 2 では標準でMariaDBがインストールされているが
#   yum install時に置き換えられるので気にしなくてOK
yum localinstall https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm -y
yum-config-manager --disable mysql80-community
yum-config-manager --enable mysql57-community
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-mysql
yum install -y mysql-community-server
echo "Installed mysql"

# 自動起動設定を入れる
systemctl enable mysqld
echo "Enabled auto start."

# confファイルを修正する
cat /home/vagrant/code/z_vagrant/etc/my.cnf >> /etc/my.cnf
echo "Updated /etc/my.cnf"

# 起動する
systemctl start mysqld
echo "Started mysql-server"

# rootのパスワードを変更する。
mysql -u root -p$(grep 'temporary password' /var/log/mysqld.log | awk '{print $11}') --connect-expired-password -e"set password for root@localhost=password('Password01!');"
mysql -u root -pPassword01! -e"SET GLOBAL validate_password_length=4;SET GLOBAL validate_password_policy=LOW;set password for root@localhost=password('root');"
echo "Changed root password."

# ローカルネットワークから接続可能なrootユーザーを作る。
mysql -u root -proot -e"GRANT ALL PRIVILEGES ON *.* TO root@'192.168.%' IDENTIFIED BY 'root' WITH GRANT OPTION;"
echo "Make root user for local network."

# ロックファイルを作成する
touch /home/vagrant/.features/mysql
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"
