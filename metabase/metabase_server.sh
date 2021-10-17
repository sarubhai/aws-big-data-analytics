#!/bin/bash
# Name: metabase_server.sh
# Owner: Saurav Mitra
# Description: Configure Metabase, MySQL & Nginx Webserver

sudo apt-get --assume-yes --quiet update                                >> /dev/null
sudo apt-get --assume-yes --quiet dist-upgrade                          >> /dev/null
sudo apt-get --assume-yes --quiet install software-properties-common    >> /dev/null
sudo add-apt-repository universe

# Adding Swap Space
fallocate -l 1G /swapfile # creates SWAP space
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
sysctl vm.swappiness=10
sysctl vm.vfs_cache_pressure=50
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure=50' | sudo tee -a /etc/sysctl.conf


# Install nginx
sudo apt-get --assume-yes --quiet install nginx                         >> /dev/null

WEBROOT='/var/www/app'
WEBUSER='appuser'

[ -d $WEBROOT ] || mkdir $WEBROOT
mkdir $WEBROOT/logs
useradd -b $WEBROOT -d $WEBROOT -s /bin/false $WEBUSER
chmod 755 $WEBROOT
chown -R $WEBUSER:$WEBUSER $WEBROOT/*

# Nginx Server Block
rm -rf /etc/nginx/sites-available/default
rm -rf /etc/nginx/sites-enabled/default

sudo tee /etc/nginx/sites-available/metabase &>/dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name app;
    root $WEBROOT;
    
    access_log $WEBROOT/logs/access.log;
    error_log  $WEBROOT/logs/error.log;
    client_max_body_size 500M;
    
    gzip  on;
    gzip_http_version 1.1;
    gzip_vary on;
    gzip_comp_level 6;
    gzip_proxied any;
    gzip_types text/plain text/html text/css application/json application/javascript application/x-javascript text/javascript text/xml application/xml application/rss+xml application/atom+xml application/rdf+xml;
    gzip_buffers 16 8k;
    gzip_disable “MSIE [1-6].(?!.*SV1)”;
    
    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_set_header    host \$host;
        proxy_http_version  1.1;
        proxy_set_header upgrade \$http_upgrade;
        proxy_set_header connection "upgrade";
    }
}
EOF

ln -sf /etc/nginx/sites-available/metabase /etc/nginx/sites-enabled/metabase
sudo systemctl restart nginx


# Install Database
MARIA_DB_SIGNING_KEY="0xF1656F24C74CD1D8"
MARIA_DB_VERSION="10.5"
# Add the MariaDB repository to sources list"
# refer https://mariadb.com/kb/en/installing-mariadb-deb-files/
apt-key adv --recv-keys --keyserver keyserver.ubuntu.com $MARIA_DB_SIGNING_KEY      2>&1 1> /dev/null

sudo tee -a /etc/apt/sources.list &>/dev/null <<EOF

# MariaDB $MARIA_DB_VERSION repository list
# http://downloads.mariadb.org/mariadb/repositories/
deb http://ftp.osuosl.org/pub/mariadb/repo/$MARIA_DB_VERSION/ubuntu focal main
deb-src http://ftp.osuosl.org/pub/mariadb/repo/$MARIA_DB_VERSION/ubuntu focal main
EOF


# Install MySQL database
sudo apt-get --assume-yes --quiet update                                >> /dev/null
# generate a random password
MYSQL_ROOTPWD=`openssl rand -base64 18 | tr -d "=+/"`
echo "MySQL Database Root password is: $MYSQL_ROOTPWD" >> /root/creds.txt
debconf-set-selections <<< "mariadb-server-$MARIA_DB_VERSION mysql-server/root_password password $MYSQL_ROOTPWD"
debconf-set-selections <<< "mariadb-server-$MARIA_DB_VERSION mysql-server/root_password_again password $MYSQL_ROOTPWD"
sudo apt-get --assume-yes --quiet install mariadb-server                >> /dev/null
sudo systemctl start mysql


# Create Metabase database & an user
MYSQL_TMPFILE="/tmp/add_new_database_file.sql"
MYSQL_NAME="db_metabase"
MYSQL_USER="db_metabase_usr"
MYSQL_PASS=`openssl rand -base64 18 | tr -d "=+/"`
echo "MySQL Database Metabase password is: $MYSQL_PASS" >> /root/creds.txt
# Create a temp .sql file
touch $MYSQL_TMPFILE
echo "CREATE DATABASE $MYSQL_NAME CHARACTER SET \"utf8\";"              >> $MYSQL_TMPFILE
echo "CREATE USER $MYSQL_USER@127.0.0.1 IDENTIFIED BY \"$MYSQL_PASS\";" >> $MYSQL_TMPFILE
echo "CREATE USER $MYSQL_USER@localhost IDENTIFIED BY \"$MYSQL_PASS\";" >> $MYSQL_TMPFILE
echo "GRANT ALL PRIVILEGES ON $MYSQL_NAME.* TO $MYSQL_USER@127.0.0.1;"  >> $MYSQL_TMPFILE
echo "GRANT ALL PRIVILEGES ON $MYSQL_NAME.* TO $MYSQL_USER@localhost;"  >> $MYSQL_TMPFILE
echo "flush privileges;" >> $MYSQL_TMPFILE

cat $MYSQL_TMPFILE | mysql -uroot -p$MYSQL_ROOTPWD


# Install Metabase
sudo apt-get --assume-yes --quiet install openjdk-8-jdk openjdk-8-jre   >> /dev/null

METABASEROOT='/var/metabase'
METABASEUSER='metabase'

[ -d $METABASEROOT ] || mkdir $METABASEROOT
sudo groupadd -r $METABASEUSER
sudo useradd -r -s /bin/false -g $METABASEUSER $METABASEUSER
sudo touch /var/log/metabase.log
sudo chown syslog:adm /var/log/metabase.log

wget https://downloads.metabase.com/v0.41.0/metabase.jar
sudo cp metabase.jar $METABASEROOT
sudo chown -R $METABASEUSER:$METABASEUSER $METABASEROOT/*

sudo tee /etc/default/metabase &>/dev/null <<EOF
MB_PASSWORD_COMPLEXITY=normal
MB_PASSWORD_LENGTH=10
MB_JETTY_HOST=0.0.0.0
MB_JETTY_PORT=3000
MB_DB_TYPE=mysql
MB_DB_DBNAME=$MYSQL_NAME
MB_DB_PORT=3306
MB_DB_USER=$MYSQL_USER
MB_DB_PASS=$MYSQL_PASS
MB_DB_HOST=localhost
MB_EMOJI_IN_LOGS=false
EOF

sudo chmod 640 /etc/default/metabase

sudo tee /etc/systemd/system/metabase.service &>/dev/null <<EOF
[Unit]
Description=Metabase Server
After=syslog.target
After=network.target

[Service]
WorkingDirectory=$METABASEROOT/
ExecStart=/usr/bin/java -Xms1g -Xmx2g -jar metabase.jar
EnvironmentFile=/etc/default/metabase
User=$METABASEUSER
Type=simple
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=metabase
SuccessExitStatus=143
TimeoutStopSec=120
Restart=always

[Install]
WantedBy=multi-user.target
EOF


sudo tee /etc/rsyslog.d/metabase.conf &>/dev/null <<EOF
if $programname == 'metabase' then /var/log/metabase.log
& stop
EOF

sudo systemctl restart rsyslog.service
sudo systemctl daemon-reload
sudo systemctl start metabase.service
sudo systemctl enable metabase.service
sudo systemctl restart nginx
