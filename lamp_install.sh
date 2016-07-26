#!/bin/bash
###########################################
# Lamp Install - tehgin                   #
# July 2016                               #
#                                         #
# A basic LAMP stack installation script. #
###########################################

# Spitting out commands.
# Actual code to come later.

# Update Repositories
echo "Updating repositories..."
sudo apt-get -qq update

# Install Apache
echo "Installing Apache..."
sudo apt-get -qq install -f apache2

# Install MySQL
echo "Installing MySQL..."
sudo apt-get -qq install -f mysql-server php5-mysql

# Install MySQL Database Directory Structure
sudo mysql_install_db

# Setup MySQL
sudo mysql_secure_installation

# Install PHP
echo "Installing PHP..."
sudo apt-get -qq install -f php5 libapache2-mod-php5 php5-mcrypt

# Echo Apache Configuration Information
echo "Edit /etc/apache2/mods-enabled/dir.conf"
echo "Change index.php priority to first in mod_dir.c"
echo "Restart Apache to save changes."

# Restart Apache
sudo service apache2 restart
