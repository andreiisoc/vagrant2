package "php5-cgi php5 php5-dev php5-cli php-pear" do
  action :install
  notifies :reload, 'service[apache2]', :delayed 
end