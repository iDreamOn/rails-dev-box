# The output of all these installation steps is noisy. With this utility
# the progress report is nice and concise.

#https://github.com/rails/rails-dev-box
function install {
    echo installing $1
    shift
	yum -y install "$@"
}

function uninstall {
    echo uninstalling $1
    shift
	yum -y erase "$@"
}

echo updating package information
#yum -y update >/dev/null 2>&1

yum groupinstall "Development Tools"

echo installing ruby, rails, bundler, etc
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable --ruby --rails
source /usr/local/rvm/scripts/rvm

install Git git
install SQLite sqlite sqlite-devel
install Memcached memcached

#uninstall MariaDB mariadb-server mariadb mariadb-libs mariadb-devel
install MariaDB mariadb-server mariadb mariadb-libs mariadb-devel
systemctl start mariadb
#mysql_secure_installation
systemctl enable mariadb.service

echo Creating rails user for mysql
mysql -uroot <<SQL
GRANT ALL PRIVILEGES ON *.* to 'rails'@'localhost';
USE mysql;
UPDATE user SET PASSWORD=PASSWORD("rails") WHERE User='rails';
flush privileges;
quit
SQL

install 'Nokogiri dependencies' libxml2 libxml2-devel libxslt1-devel
install 'EPEL Repository' epel-release
install 'ExecJS runtime' nodejs
install Redis redis
install RabbitMQ rabbitmq-server

# Needed for docs generation.
#update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8

echo 'all set, rock on!'
