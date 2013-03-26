cp /vagrant/02proxy /etc/apt/apt.conf.d

# install system dependencies
apt-get update
export DEBIAN_FRONTEND=noninteractive
apt-get install -y apache2 curl git libmysqlclient-dev mysql-server nodejs \
  ruby1.9.3 apache2-suexec

# configure apache
chown vagrant:vagrant /var/www
sed -i.bak -f /vagrant/apache_default.sed /etc/apache2/sites-available/default
a2enmod suexec
echo "ServerName $(hostname)" > /etc/apache2/conf.d/servername
service apache2 restart

# install rvm
su --login vagrant << 'eof'
  \curl -L https://get.rvm.io | bash -s stable
eof

# install compiler dependencies
export rvm_path=/home/vagrant/.rvm
source $rvm_path/scripts/rvm
rvm --autolibs=enable requirements ruby-2.0.0

# install gems
gem install xmpp4r nokogiri wunderbar --no-rdoc --no-ri

# install AWDwR
su --login vagrant << 'eof'
  # install software
  mkdir $HOME/git
  cd $HOME/git
  git clone git://github.com/rubys/awdwr.git
  PATH=$PATH:/usr/sbin ruby ~/git/awdwr/setup.rb
  ruby ~/git/awdwr/dashboard.rb --install=/var/www
  cd -
  mkdir logs

  # command line interface
  mkdir bin
  sed "s'/home/rubys'$HOME'" < ~/git/awdwr/testrails.yml > bin/testrails.yml
  cp /vagrant/bin/* bin
  echo 'PATH=$PATH:$HOME/bin' >> ~/.bashrc 
  echo "alias work='source ~/bin/work'" >> ~/.bashrc 

  # web interface
  cp /vagrant/www/* /var/www
  sed "s'/home/rubys'$HOME'" < ~/git/awdwr/dashboard.yml > /var/www/dashboard.yml
  ln -s /home/vagrant/git/awdwr/edition4 /var/www/AWDwR4
  mkdir /home/vagrant/logs/
  ln -s /home/vagrant/logs/ /var/www/logs
  cp /home/vagrant/log.htaccess /home/vagrant/logs
eof

ip=$(ifconfig eth1|grep inet|head -1|sed 's/\:/ /'|awk '{print $3}')
echo
echo "Configuration complete.  Dashboard available at http://$ip/dashboard.cgi"
