#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.homestead-features/mailhog ]
then
    echo "MailHog already installed."
    exit 0
fi

# mailhogをインストールする
wget https://github.com/mailhog/MailHog/releases/download/v1.0.0/MailHog_linux_amd64 -O mailhog
chmod +x mailhog
mv mailhog /usr/local/bin
echo "Installed mailhog"

# mailhogをサービスとして登録する
cat /home/vagrant/code/z_vagrant/etc/systemd/system/mailhog.service > /etc/systemd/system/mailhog.service
systemctl daemon-reload
echo "Registered /etc/systemd/system/mailhog.service"

# 自動起動設定を入れる
systemctl enable mailhog
echo "Enabled auto start."

# 起動する
systemctl start mailhog
echo "Started mailhog"

# ロックファイルを作成する
touch /home/vagrant/.features/mailhog
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"