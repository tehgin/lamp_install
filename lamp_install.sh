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
MYSQL_ROOT_PASSWORD= # Automatically Set Via rand_pass

APACHE_VERSION= # Apache Version Information
MYSQL_VERSION= # MySQL Version Information
PHP_VERSION= # PHP Version Information

# Output Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

#########################
# ----- Functions ----- #
#########################

### Function: update_repo
# Updates repository.
update_repo ()
{
sudo apt-get update > /dev/null 2>&1
}

### Function: get_apache_version
# Obtain Apache version information.
get_apache_version ()
{
  APACHE_VERSION="$(apachectl -V | grep version | awk {'print $3'})"
}

### Function: get_mysql_version
# Obtain MySQL version information.
get_mysql_version ()
{
  MYSQL_VERSION="$(mysql -uroot -p${MYSQL_ROOT_PASSWORD} -s -N -e "select version();")"
}

### Function: get_php_version
# Obtain PHP version information.
get_php_version ()
{
  PHP_VERSION="$(php -v | grep built | awk {'print $2'})"
}

### Function: install_apache
# Installs Apache.
install_apache ()
{
sudo apt-get -qq install -f apache2 > /dev/null 2>&1
get_apache_version
}

### Function: install_mysql
# Installs MySQL, then patches known security holes.
install_mysql ()
{
rand_pass # Generate random password for MySQL root user.

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

get_mysql_version
}

### Function: install_php
# Installs PHP and select modules.
install_php ()
{
sudo apt-get -qq install -f php5 libapache2-mod-php5 php5-mcrypt > /dev/null 2>&1
get_php_version
}

### Function: configure_apache
# Configures Apache then restarts the service.
configure_apache ()
{
sed -i 's/DirectoryIndex\ index.html\ index.cgi\ index.pl\ index.php\ index.xhtml\ index.htm/DirectoryIndex\ index.php\ index.html\ index.cgi\ index.pl\ index.xhtml\ index.htm/g' /etc/apache2/mods-enabled/dir.conf
sudo service apache2 restart > /dev/null 2>&1 # Restart Apache
}

### Function: rand_pass
# Randomizes password for MySQL root user.
rand_pass ()
{
MYSQL_ROOT_PASSWORD="$(< /dev/urandom tr -dc 'a-zA-Z0-9' | head -c${1:-32})"
}

#######################
# ----- Execute ----- #
#######################

echo ""
echo "${CYAN}#########################${NC}"
echo "${CYAN}# LAMP INSTALL - tehgin #${NC}"
echo "${CYAN}#########################${NC}"
echo ""

echo "Updating package lists..."
update_repo
echo "Ready! Attempting to install software stack now."
echo ""

install_apache
echo "${GREEN}Apache installed!${NC} (${APACHE_VERSION})"

install_mysql
echo "${GREEN}MySQL installed!${NC} (${MYSQL_VERSION})"

install_php
echo "${GREEN}PHP installed!${NC} (${PHP_VERSION})"

configure_apache
echo ""
echo "${GREEN}Configurations complete!${NC}"

echo ""
echo "${NC}MySQL Root Password: ${RED}${MYSQL_ROOT_PASSWORD}${NC}"
echo "Copy this password as it's not stored anywhere! You WILL lose it."

echo ""
echo "${CYAN}Have a nice day!${NC}"
echo ""
