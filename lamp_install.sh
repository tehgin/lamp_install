#!/bin/bash
###########################################
# LAMP Install - tehgin                   #
# July 2016                               #
#                                         #
# A basic LAMP stack installation script. #
###########################################

#########################
# ----- Variables ----- #
#########################
MYSQL_ROOT_PASSWORD=ybzKriEr1IW3EQDF6u32 # Randomly Generated For Testing

#########################
# ----- Functions ----- #
#########################

### Function: update_repo
function update_repo {
sudo apt-get -qq update > /dev/null 2>&1
}

### Function: install_apache
function install_apache {
sudo apt-get -qq install -f apache2 > /dev/null 2>&1
}

### Function: install_mysql
function install_mysql {
echo "mysql-server mysql-server/root_password password ${MYSQL_ROOT_PASSWORD}" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${MYSQL_ROOT_PASSWORD}" | sudo debconf-set-selections
sudo apt-get -qq install -f mysql-server php5-mysql > /dev/null 2>&1 # Install MySQL

sudo mysql_install_db > /dev/null 2>&1 # Install MySQL Database Directory Structure

# Set MySQL Root Password
mysqladmin -u root -p$MYSQL_ROOT_PASSWORD password $MYSQL_ROOT_PASSWORD
# Delete Anonymous Users
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User=''"
# Remove Remote Login For MySQL Root User
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
# Delete Test Database
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
# Flush Privileges
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES"
}

### Function: install_php
function install_php {
sudo apt-get -qq install -f php5 libapache2-mod-php5 php5-mcrypt > /dev/null 2>&1
}

### Function: configure_apache
function configure_apache {
echo "Edit /etc/apache2/mods-enabled/dir.conf"
echo "Change index.php priority to first in mod_dir.c"
echo "Restart Apache to save changes."
sudo service apache2 restart > /dev/null 2>&1 # Restart Apache
}

#######################
# ----- Execute ----- #
#######################
update_repo
install_apache
install_mysql
install_php
configure_apache
