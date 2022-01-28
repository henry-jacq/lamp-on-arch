#!/bin/bash

# Author: Henry
# Date: 27/01/2022
#
# Description: LAMP stack setup on Arch linux.
#

# Install packages
# Configure apache
# Configure PHP
# Configure apache directory load to php
# Configure Mysql
# Configure Mysql_secure_installation
# Setup Adminer
# Setup Adminer theme (dracula)

function title(){
    echo -e "\n\tLAMP server Installer for Arch Linux\n"
}

function check_root(){
    clear
    if [[ $UID != 0 ]]; then
        title
        echo "-> Run as root"
        echo -e "-> Usage: sudo $0\n"
        exit
    else
        title
        echo -e "==> Starting lamp server installation\n"
    fi
}

function install_pkgs(){
    echo -e "-> Installing LAMP stack packages\n"
    echo -e "-> Updating pacman database\n"
    pacman -Syy

#     pkgs=(apache php php-apache php-cgi php-mcrypt php-gd php-pgsql php-imagick mariadb mariadb-clients phpmyadmin) # adminer
    pkgs="apache php php-apache php-cgi php-mcrypt php-gd php-pgsql php-imagick mariadb mariadb-clients phpmyadmin" # adminer

#     for $i in ${pkgs[@]}; do
#         echo -e "-> [*] Installing $i"
#         pacman -S $i
#     done
    pacman -S --noconfirm $pkgs
    echo "==> packages installed."
}

function configure_apache(){
    echo -e "==> Configuring apache...\n"
    echo -e "-> Starting apache web server\n"

    systemctl start httpd

    echo -e "-> Disabling User Directories\n"
    sed -i  's\Include conf/extra/httpd-userdir.conf\# Include conf/extra/httpd-userdir.conf\' /etc/httpd/conf/httpd.conf && echo -e "-> Disabled successfully\n"

    echo -e "-> Enabling support for php in apache\n"
    echo "" >> /etc/httpd/conf/httpd.conf
    echo "LoadModule php_module modules/libphp.so" >> /etc/httpd/conf/httpd.conf
    echo "AddHandler php-script .php" >> /etc/httpd/conf/httpd.conf
    echo "Include conf/extra/php_module.conf" >> /etc/httpd/conf/httpd.conf

#     echo -e "-> Creating public_html in your home folder $HOME\n"
#     mkdir ~/public_html
#     chmod o+x ~/public_html
#     chmod -R o+r ~/public_html

    # Change in php.ini
    echo -e "==> Modifying php.ini\n"
    sleep 1
    echo -e "=> Disabling mpm_event_module\n"
    sed -i  's/LoadModule mpm_event_module/#LoadModule mpm_event_module/' /etc/httpd/conf/httpd.conf
    sed -i  's/#LoadModule mpm_prefork_module/LoadModule mpm_prefork_module/' /etc/httpd/conf/httpd.conf
    sleep 1
    echo -e "=> Enabling short_open_tag support\n"
    sed -i  's/short_open_tag = Off/short_open_tag = On/' /etc/php/php.ini
    sleep 1
    echo -e "=> Enabling php extensions bz2 gd mysqli pdo_mysql\n"
    sed -i  's/;extension=bz2/extension=bz2/' /etc/php/php.ini
    sed -i  's/;extension=gd/extension=gd/' /etc/php/php.ini
    sed -i  's/;extension=mysqli/extension=mysqli/' /etc/php/php.ini
    sed -i  's/;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/php.ini
    sleep 1
    echo -e "=> Creating phpmyadmin configuration\n"
    touch /etc/httpd/conf/extra/phpmyadmin.conf
echo "
Alias /phpmyadmin "/usr/share/webapps/phpMyAdmin"
<Directory "/usr/share/webapps/phpMyAdmin">
    DirectoryIndex index.php
    AllowOverride All
    Options FollowSymlinks
    Require all granted
</Directory> " > /etc/httpd/conf/extra/phpmyadmin.conf

    echo -e "=> phpMyAdmin config modified\n"
    sleep 1
    echo "-> phpMyAdmin included in apache config"
    echo "" >> /etc/httpd/conf/httpd.conf
    echo "Include conf/extra/phpmyadmin.conf" >> /etc/httpd/conf/httpd.conf

    echo "-> Enabling cookie based authentication in phpMyAdmin config\n"
    sleep 1
    sed -i  's/$cfg['blowfish_secret'] = '';/$cfg['blowfish_secret'] = ‘{^QP+-(3mlHy+Gd~FE3mN{gIATs^1lX+T=KVYv{ubK*U0V’ ;/' /etc/webapps/phpmyadmin/config.inc.php
    sleep 1

    echo -e "=> Restarting apache to apply the changes made before.\n"
    systemctl restart httpd
    echo -e "-> Restarted successfully\n"

}

function configure_mysql(){

    echo -e "==> Setting up mysql\n"
    echo -e "-> Installing mysql in your system\n"
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
    echo -e "-> Starting mysql now\n"
    systemctl start mysqld
    echo -e "-> Setting up mysql secure installtion\n"
    mysql_secure_installation

    read -p "-> If you want to create new user in mysql database [y/n]" opt

    case $opt in
        y | Y)
            Create a new database and granting privileges to user
            read -p "-> Enter Username: " $username
            read -p -s "-> Enter Password: " $userpass
            read -p "-> Enter database name: " $dbname
            echo "-> Creating new user..."
            mysql -e "CREATE USER ${username}@localhost IDENTIFIED BY '${userpass}';"
            echo "User successfully created!"
            echo "-> Granting privileges to user ${username} on database ${dbname}"
            mysql -e "GRANT ALL PRIVILEGES ON ${dbname}.* TO '${username}'@'localhost';"
            mysql -e "FLUSH PRIVILEGES;"
            echo "-> Done, You're good now :)"
        ;;
        n | N)
            echo -e "-> User not created !"
        ;;
        *)
            echo "-> Invalid option"
        ;;
    esac
}

function lamp_setup(){
    read -p "-> If you want to enable lamp system wide [y/n] " option
    case $option in
        y | Y)
            echo -e "\n=> LAMP enabled system wide\n"
            systemctl enable httpd mysqld
        ;;
        n | N)
            echo -e "\n=> Thanks for using this script\n"
        ;;
        *)
            echo "\n-> Invalid option\n"
        ;;
    esac
}

# function configure_adminer(){}

## Call functions

check_root
install_pkgs
configure_apache
configure_mysql
lamp_setup
