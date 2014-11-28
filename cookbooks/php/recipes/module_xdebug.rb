package 'php5-xdebug' do
  action :install
  notifies :reload, 'service[apache2]', :delayed 
end

template "/etc/php5/mods-available/xdebug.ini" do
	source 'xdebug.ini.erb' 
	action :create
	notifies :reload, 'service[apache2]', :delayed 
end