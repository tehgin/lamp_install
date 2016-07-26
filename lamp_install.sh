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
sudo apt-get update

# Install Apache
sudo apt-get install apache2

# Install MySQL
sudo apt-get install mysql-server php5-mysql

# Install MySQL Database Directory Structure
sudo mysql_install_db

# Setup MySQL
sudo mysql_secure_installation

# Install PHP
sudo apt-get install php5 libapache2-mod-php5 php5-mcrypt

# Echo Apache Configuration Information
echo "Edit /etc/apache2/mods-enabled/dir.conf"
echo "Change index.php priority to first in mod_dir.c"
echo "Restart Apache to save changes."

# Restart Apache
sudo service apache2 restart
