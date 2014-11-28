package "php5-cgi php5 php5-dev php5-cli php-pear" do
  action :install
  notifies :run, 'execute[reload apache]'
end

execute 'reload apache' do
	command "service apache2 reload"
  only_if { ::File.exists?("/etc/apache2/apache2.conf") }
end