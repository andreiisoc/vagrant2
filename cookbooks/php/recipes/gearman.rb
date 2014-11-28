package "libgearman-dev" do
  action :install
end

execute "install gearman with pecl" do
  command "pecl install gearman"
  not_if { ::File.exists?("/etc/php5/mods-available/gearman.ini") }
end

template "/etc/php5/mods-available/gearman.ini" do
	source 'gearman.ini.erb' 
	action :create_if_missing
	notifies :run, 'execute[enable mode]'
end

execute "enable mode" do
  command "php5enmod gearman"
  action :run
  notifies :run, 'execute[reload apache]'
end

execute 'reload apache' do
	command "service apache2 reload"
  only_if { ::File.exists?("/etc/apache2/apache2.conf") }
end