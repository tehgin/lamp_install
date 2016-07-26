#!/bin/bash
###########################################
# LAMP Install - tehgin                   #
# July 2016                               #
#                                         #
# A basic LAMP stack installation script. #
###########################################

#############
# Variables #
#############
MYSQL_ROOT_PASSWORD=ybzKriEr1IW3EQDF6u32 # Randomly Generated For Testing

#######################
# Update Repositories #
#######################
echo "Updating repositories..."
sudo apt-get -qq update > /dev/null 2>&1


##################
# Install Apache #
##################
echo "Installing Apache..."
sudo apt-get -qq install -f apache2 > /dev/null 2>&1


#################
# Install MySQL #
#################
echo "Installing MySQL..."
sudo apt-get -qq install -f mysql-server php5-mysql


##############################################
# Install MySQL Database Directory Structure #
##############################################
sudo mysql_install_db

###############
# Setup MySQL #
###############
echo "Setting up MySQL..."

# Replacement For mysql_secure_installation
mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root'"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.user WHERE User=''"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "FLUSH PRIVILEGES"

###############
# Install PHP #
###############
echo "Installing PHP..."
sudo apt-get -qq install -f php5 libapache2-mod-php5 php5-mcrypt > /dev/null 2>&1

#########################################
# Echo Apache Configuration Information #
#########################################
echo "Edit /etc/apache2/mods-enabled/dir.conf"
echo "Change index.php priority to first in mod_dir.c"
echo "Restart Apache to save changes."

##################
# Restart Apache #
##################
echo "Restarting Apache..."
sudo service apache2 restart > /dev/null 2>&1
