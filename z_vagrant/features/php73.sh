#!/usr/bin/env bash

# ロックファイルの確認をする
if [ -f /home/vagrant/.features/php73 ]
then
    echo "PHP 7.3 already installed."
    exit 0
fi

# php 7.3のインストール
#
#   Laravel 6.x系での必須要件は以下の通り
#     PHP >= 7.2.0
#     BCMath    (php-bcmath)
#     Ctype     (php7.3のインストール時に含まれる)
#     JSON      (php-json)
#     Mbstring  (php-mbstring)
#     OpenSSL   (php7.3のインストール時に含まれる)
#     PDO       (php-pdo)
#     Tokenizer (php7.3のインストール時に含まれる)
#     XML       (php-xml)
amazon-linux-extras install -y php7.3
yum install -y php-bcmath php-mbstring php-xml php-opcache php-pear php-devel
echo "Installed php7.3"

# xdebugのインストール
pecl install xdebug
echo "Installed xdebug"

# confファイルを修正する
cat /home/vagrant/code/z_vagrant/etc/php-fpm.d/www.conf > /etc/php-fpm.d/www.conf
echo "Updated /etc/php-fpm.d/www.conf"
cat /home/vagrant/code/z_vagrant/etc/php.ini > /etc/php.ini
echo "Updated /etc/php.ini"
cat /home/vagrant/code/z_vagrant/etc/php.d/10-opcache.ini > /etc/php.d/10-opcache.ini
echo "Updated /etc/php.d/10-opcache.ini"
cat /home/vagrant/code/z_vagrant/etc/php.d/30-xdebug.ini > /etc/php.d/30-xdebug.ini
echo "Created /etc/php.d/30-xdebug.ini"

# composerのインストール
php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
php /tmp/composer-setup.php --filename=composer
php -r "unlink('/tmp/composer-setup.php');"
mv composer /usr/local/bin/composer
echo "Installed composer"

# ロックファイルを作成する
touch /home/vagrant/.features/php73
chown -Rf vagrant:vagrant /home/vagrant/.features
echo "Complete !!"
