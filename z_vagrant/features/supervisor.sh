#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.features/supervisor ]
then
    echo "Supervisord already installed."
    exit 0
fi

# Supervisorをインストールする
easy_install pip
pip install supervisor
echo_supervisord_conf > /etc/supervisord.conf
echo "Installed supervisor"

# confファイルを修正する
cat /home/vagrant/code/z_vagrant/etc/supervisord.conf > /etc/supervisord.conf
touch /var/run/supervisor.sock
chmod 777 /var/run/supervisor.sock
echo "Updated /etc/supervisord.conf"

# ユーザー定義のconfファイルを配置する
mkdir -p /etc/supervisor/conf.d
find ${1} -name '*.conf' -mindepth 1 -maxdepth 1 -print0 | while read -d $'\0' file; do
    cp ${file} /etc/supervisor/conf.d/
done
echo "Created /etc/supervisor/conf.d/*.conf"

# Supervisorをサービスとして登録する
cat /home/vagrant/code/z_vagrant/etc/systemd/system/supervisord.service > /etc/systemd/system/supervisord.service
systemctl daemon-reload
echo "Registered /etc/systemd/system/supervisord.service"

# 自動起動設定を入れる
systemctl enable supervisord
echo "Enabled auto start."

# 起動する
systemctl start supervisord
echo "Started supervisord"

# ロックファイルを作成する
touch /home/vagrant/.features/supervisor
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"