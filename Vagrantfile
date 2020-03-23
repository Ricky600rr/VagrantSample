# -*- mode: ruby -*-
# vi: set ft=ruby :

# 環境定数
VAGRANT_HOME = File.expand_path('z_vagrant', File.dirname(__FILE__))
FEATURES_DIR = File.expand_path('features', VAGRANT_HOME)

Vagrant.configure('2') do |config|
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # 共通項目
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # 使用するBoxの定義
    config.vm.box= 'amazonlinux2'

    # /home/vagrant/code/配下に、このプロジェクト全体を同期する。
    config.vm.synced_folder '.', '/home/vagrant/code'

    # AgentForwardを許可する
    config.ssh.forward_agent = true

    # 鍵の置換は行わない
    config.ssh.insert_key = false

    # Authorized Keyを設定する
    config.vm.provision "shell", inline: "cat /home/vagrant/code/z_vagrant/.ssh/vagrant.pub > /home/vagrant/.ssh/authorized_keys"

    # Provisioning時の再実行を避ける為のロックファイルの置き場を作る
    config.vm.provision "shell", inline: "mkdir -p /home/vagrant/.features"
    config.vm.provision "shell", inline: "chown -Rf vagrant:vagrant /home/vagrant/.features"

    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # Batchサーバーを作成する
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    config.vm.define "batch-server" do |server|
        server.vm.provider "virtualbox" do |vb|
            vb.memory = 1024
            vb.cpus   = 1
            vb.name   = "batch.vagrant"
        end
        server.vm.hostname = "batch.vagrant"
        server.vm.network "private_network", ip: "192.168.100.100"

        # 設定用のShellScriptを実行する。
        server.vm.provision "shell", path: File.expand_path("amzlnx2.sh", FEATURES_DIR)
        server.vm.provision "shell", path: File.expand_path("php73.sh", FEATURES_DIR)
        server.vm.provision :shell do |shell|
           shell.path = File.expand_path("apache.sh", FEATURES_DIR)
           shell.args = ["/home/vagrant/code/z_vagrant/appends/apache/batch"]
        end
        server.vm.provision :shell do |shell|
           shell.path = File.expand_path("supervisor.sh", FEATURES_DIR)
           shell.args = ["/home/vagrant/code/z_vagrant/appends/supervisor"]
        end
        server.vm.provision "shell", path: File.expand_path("minio.sh", FEATURES_DIR)
        server.vm.provision "shell", path: File.expand_path("mailhog.sh", FEATURES_DIR)
    end

    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # Webサーバーを作成する
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    config.vm.define "web-server" do |server|
        server.vm.provider "virtualbox" do |vb|
            vb.memory = 1024
            vb.cpus   = 1
            vb.name   = "web.vagrant"
        end
        server.vm.hostname = "web.vagrant"
        server.vm.network "private_network", ip: "192.168.100.10"

        # 設定用のShellScriptを実行する。
        server.vm.provision "shell", path: File.expand_path("amzlnx2.sh", FEATURES_DIR)
        server.vm.provision "shell", path: File.expand_path("php73.sh", FEATURES_DIR)
        server.vm.provision :shell do |shell|
           shell.path = File.expand_path("apache.sh", FEATURES_DIR)
           shell.args = ["/home/vagrant/code/z_vagrant/appends/apache/web"]
        end
        server.vm.provision "shell", path: File.expand_path("minio-client.sh", FEATURES_DIR)
    end

    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # Mysqlサーバーを作成する
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    config.vm.define "mysql-server" do |server|
        server.vm.provider "virtualbox" do |vb|
            vb.memory = 1024
            vb.cpus   = 1
            vb.name   = "mysql.vagrant"
        end
        server.vm.hostname = "mysql.vagrant"
        server.vm.network "private_network", ip: "192.168.100.200"

        # 設定用のShellScriptを実行する。
        server.vm.provision "shell", path: File.expand_path("amzlnx2.sh", FEATURES_DIR)
        server.vm.provision "shell", path: File.expand_path("mysql.sh", FEATURES_DIR)
    end

    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    # Redisサーバーを作成する
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    config.vm.define "redis-server" do |server|
        server.vm.provider "virtualbox" do |vb|
            vb.memory = 1024
            vb.cpus   = 1
            vb.name   = "redis.vagrant"
        end
        server.vm.hostname = "redis.vagrant"
        server.vm.network "private_network", ip: "192.168.100.210"

        # 設定用のShellScriptを実行する。
        server.vm.provision "shell", path: File.expand_path("amzlnx2.sh", FEATURES_DIR)
        server.vm.provision "shell", path: File.expand_path("redis.sh", FEATURES_DIR)
    end
end
