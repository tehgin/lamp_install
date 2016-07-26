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

# Credit for method: https://gist.github.com/Mins/4602864
sudo apt-get -qq install -f expect > /dev/null 2>&1 # Install Expect

# Setup Expect
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

# Execute Expect
echo "$SECURE_MYSQL"

sudo apt-get -qq purge -f expect > /dev/null 2>&1 # Purge Expect

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
