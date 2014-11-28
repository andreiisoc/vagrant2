include_recipe "git" 

execute "clone webgrind" do
  cwd "/var/www"
  command "git clone https://github.com/jokkedk/webgrind.git"
  not_if { ::File.exists?("/var/www/webgrind/index.php")}
end

directory "/var/www/webgrind" do
  user "vagrant"
  group "www-data"
  recursive true
end

template "/etc/apache2/sites-available/webgrind.conf" do
  source 'webgrind.conf.erb' 
  variables(
      :fqdn => node[:fqdn]
  )
  action :create
  notifies :reload, 'service[apache2]', :delayed
end

execute "enable webgrind" do
  command "a2ensite webgrind"
  not_if { ::File.exists?("/etc/apache2/sites-enabled/webgrind.conf")}
  notifies :reload, 'service[apache2]', :delayed
end