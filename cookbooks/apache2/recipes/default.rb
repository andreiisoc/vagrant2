package "apache2" do
  action :install
end

service "apache2" do
  #service_name "apache2"
  #provider Chef::Provider::Service::Upstart
  supports :status => true, :start => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

template "/etc/apache2/ports.conf" do
  source 'ports.conf.erb'
  mode   '0644' 
  notifies :reload, "service[apache2]", :delayed 
end

template "/etc/apache2/sites-available/000-default.conf" do
  source '000-default.conf.erb'
  mode   '0644' 
  notifies :reload, "service[apache2]", :delayed 
end

file "/var/www/html/index.html" do
  action :delete
end