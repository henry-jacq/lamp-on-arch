#!/bin/bash

# Maintainer: Henry
# Created on: 27/01/2022
#
# Description: LAMP server setup on Arch linux.
#

function check_root(){
    clear
    if [[ $UID != 0 ]]; then
        echo "-> Run as root"
        echo -e "-> Usage: sudo $0\n"
        exit
    else
        echo -e "==> Starting lamp server installation\n"
    fi
}

function install_pkgs(){
    echo -e "-> Installing LAMP stack packages\n"
    echo -e "-> Updating pacman database\n"
    pacman -Syy

#     pkgs=(apache php php-apache php-cgi php-mcrypt php-gd php-pgsql php-imagick mariadb mariadb-clients phpmyadmin) # adminer
    pkgs="apache php php-apache php-cgi php-gd php-pgsql php-imagick mariadb mariadb-clients phpmyadmin" # adminer

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

    # Deleting the inclusion of User Directories
    echo -e "-> Deleting User Directories entry in httpd config\n"
    sed -i  '\Include conf/extra/httpd-userdir.conf\d' /etc/httpd/conf/httpd.conf && echo -e "-> Disabled successfully\n"

    # Adding support for PHP
    echo -e "-> Enabling support for php in apache\n"
    echo "" >> /etc/httpd/conf/httpd.conf
    echo "LoadModule php_module modules/libphp.so" >> /etc/httpd/conf/httpd.conf
    echo "AddHandler php-script .php" >> /etc/httpd/conf/httpd.conf
    echo "" >> /etc/httpd/conf/httpd.conf
    echo "# Support for PHP" >> /etc/httpd/conf/httpd.conf
    echo "Include conf/extra/php_module.conf" >> /etc/httpd/conf/httpd.conf

    # Adding custom settings to php.ini
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

    # Adding support for phpMyAdmin
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
    echo -e "=> phpMyAdmin config modified successfully\n"
    sleep 1
    echo -e "-> phpMyAdmin included in httpd config\n"
    echo "" >> /etc/httpd/conf/httpd.conf
    echo "# support for phpMyAdmin" >> /etc/httpd/conf/httpd.conf
    echo "Include conf/extra/phpmyadmin.conf" >> /etc/httpd/conf/httpd.conf

    # Adding support for Adminer
    echo -e "-> Installing Adminer\n"
    pacman -U adminer-4.8.1-1-any.pkg.tar.zst --noconfirm
    echo -e "-> Adminer included in httpd config\n"
    echo "" >> /etc/httpd/conf/httpd.conf
    echo "# support for Adminer" >> /etc/httpd/conf/httpd.conf
    echo "Include conf/extra/httpd-adminer.conf" >> /etc/httpd/conf/httpd.conf
    echo -e "-> Adding dracula theme to Adminer\n"
    cd /usr/share/webapps/adminer/
    wget https://raw.githubusercontent.com/vrana/adminer/master/designs/dracula/adminer.css
    echo -e "=> Theme added! \n"
    cd ~

    # Enabling cookie support in phpMyAdmin
    echo -e "-> Enabling cookie based authentication in phpMyAdmin config\n"
    sleep 1
    sed -i  's/$cfg['blowfish_secret'] = '';/$cfg['blowfish_secret'] = ‘{^QP+-(3mlHy+Gd~FE3mN{gIATs^1lX+T=KVYv{ubK*U0V’ ;/' /etc/webapps/phpmyadmin/config.inc.php
    sleep 1

    # saving changes and restarting the service
    echo -e "=> Restarting apache to apply the changes made before.\n"
    systemctl restart httpd
    echo -e "-> Restarted successfully\n"
}

function configure_mysql(){

    # Installing mysql base
    echo -e "==> Setting up mysql\n"
    echo -e "-> Installing mysql in your system\n"
    mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

    # Starting mysql service
    echo -e "-> Starting mysql now\n"
    systemctl start mysqld

    # Setting up mysql_secure_installation
    echo -e "-> Setting up mysql secure installtion\n"
    mysql_secure_installation

    # Create user if yes
    read -p "-> If you want to create new user in mysql database [y/n]" opt
    case $opt in
        y | Y)
            echo -e "=> Create a new database and granting privileges to user\n"
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

## Call functions

check_root
install_pkgs
configure_apache
configure_mysql
lamp_setup
